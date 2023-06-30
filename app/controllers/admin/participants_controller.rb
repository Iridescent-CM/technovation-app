module Admin
  class ParticipantsController < AdminController
    include DatagridController

    helper_method :parental_consent_pending?

    use_datagrid with: AccountsGrid

    def show
      @account = Account.find(params.fetch(:id))
      @teams = Team.current
      @scores = submission_score
      @recused_scores = recused_scores
      @season_flag = SeasonFlag.new(@account)
      @certificates = @account.current_certificates
      @needed_certificates = DetermineCertificates.new(@account).needed
    end

    def edit
      @account = Account.find(params.fetch(:id))
    end

    def update
      @account = Account.find(params.fetch(:id))
      profile = @account.send("#{@account.scope_name}_profile")

      profile_params = account_params.delete(
        "#{@account.scope_name}_profile"
      ) || {}

      profile_params[:account_attributes] = {
        id: params.fetch(:id)
      }.merge(account_params)

      if ProfileUpdating.execute(
        profile,
        @account.scope_name,
        profile_params
      )
        redirect_to admin_participant_path(@account),
          success: "You updated #{@account.full_name}'s account"
      else
        render :edit
      end
    end

    def destroy
      account = Account.find(params[:id])

      DeleteAccountFromEmailListJob.perform_later(email_address: account.email)
      account.destroy

      redirect_to admin_participants_path,
        success: "#{account.name} was removed from Technovation Girls"
    end

    def permanently_delete
      account = Account.find(params[:participant_id])

      DeleteAccountFromEmailListJob.perform_later(email_address: account.email)
      ConsentWaiver.find_by(account_id: account.id)&.delete

      account.really_destroy!

      redirect_to admin_participants_path,
        success: "#{account.name} was permanently deleted from Technovation Girls"
    end

    private

    def grid_params
      grid = (params[:accounts_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:accounts_grid][:country]),
        state_province: Array(params[:accounts_grid][:state_province]),
        season: params[:accounts_grid][:season] || Season.current.year,
        season_and_or: params[:accounts_grid][:season_and_or] ||
                         "match_any",
        mentor_types: params[:accounts_grid][:mentor_types]
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end

    def account_params
      @account_params ||= params.require(:account).permit(
        :id,
        :email,
        :first_name,
        :last_name,
        :date_of_birth,
        :gender,
        :geocoded,
        :city,
        :state_province,
        :country,
        :latitude,
        :longitude,
        :profile_image,
        :profile_image_cache,
        :password,
        mentor_profile: {},
        student_profile: {},
        judge_profile: {},
        chapter_ambassador_profile: {}
      ).tap do |tapped|
        tapped[:skip_existing_password] = true
        tapped[:admin_making_changes] = true
      end
    end

    def parental_consent_pending?
      if @account.present? && @account.student_profile.present?
        if !@account.parental_consent.present?
          @account.student_profile.create_parental_consent!
          @account.reload
        end

        @account.parental_consent.pending?
      else
        false
      end
    end

    def submission_score
      if @account.judge_profile.present?
        @account.judge_profile.submission_scores.current.with_deleted.complete_and_incomplete_without_recused
      else
        SubmissionScore.none
      end
    end

    def recused_scores
      if @account.judge_profile.present?
        @account.judge_profile.submission_scores.recused
      else
        SubmissionScore.none
      end
    end
  end
end
