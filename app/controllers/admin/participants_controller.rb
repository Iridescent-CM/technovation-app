module Admin
  class ParticipantsController < AdminController
    include DatagridController

    helper_method :parental_consent_pending?

    use_datagrid with: AccountsGrid

    def show
      @account = Account.find(params.fetch(:id))
      @teams = Team.current
      @scores = submission_score(@account)
      @season_flag = SeasonFlag.new(@account)
      @certificate_recipient = CertificateRecipient.new(@account)

      @badge_recipients = []
      @certificate_recipients = []

      if @account.judge_profile
        @account.seasons.each do |season|
          badge = BadgeRecipient.new(@account.judge_profile, season: season)

          @badge_recipients.push(badge) if badge.valid?
        end
      end
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
        id: params.fetch(:id),
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
      list_id = "#{account.scope_name.upcase}_LIST_ID"

      DeleteAccountJob.perform_later(list_id, account.email)
      account.destroy

      redirect_to admin_participants_path,
        success: "#{account.name} was deleted"
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
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
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
        regional_ambassador_profile: {},
      ).tap do |tapped|
        tapped[:skip_existing_password] = true
        tapped[:admin_making_changes] = true
      end
    end

    def parental_consent_pending?
      if @account.present? and @account.student_profile.present?
        if not @account.parental_consent.present?
          @account.student_profile.create_parental_consent!
          @account.reload
        end

        @account.parental_consent.pending?
      else
        false
      end
    end

    def submission_score(account)
      if account.judge_profile.present?
        account.judge_profile.submission_scores.current.complete
      else
        SubmissionScore.none
      end
    end

  end
end
