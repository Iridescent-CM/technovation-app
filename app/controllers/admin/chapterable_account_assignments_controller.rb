module Admin
  class ChapterableAccountAssignmentsController < AdminController
    before_action :get_chapterables

    def new
      @account = Account.find(params.fetch(:account_id))
      @chapterable_account_assignment = ChapterableAccountAssignment.new
    end

    def create
      @account = Account.find(params.fetch(:account_id))
      chapterable_type = chapterable_account_assignment_params.fetch(:chapterable_type)
      chapterable_id = chapterable_account_assignment_params.fetch(:chapter_id).presence ||
        chapterable_account_assignment_params.fetch(:club_id).presence

      @account
        .current_chapterable_assignments
        .where(primary: true)
        .delete_all

      if chapterable_id.present?
        assignment = @account.chapterable_assignments.create(
          profile: @account.chapter_ambassador_profile.presence ||
            @account.club_ambassador_profile.presence ||
            @account.mentor_profile.presence ||
            @account.student_profile,
          chapterable_id: chapterable_id,
          chapterable_type: chapterable_type.capitalize,
          season: Season.current.year,
          primary: true
        )

        if assignment.save
          @account.update(no_chapterable_selected: nil)
          @account.update(no_chapterables_available: nil)
          redirect_to admin_participant_path(@account),
            success: "Successfully assigned #{@account.full_name} to a new #{chapterable_type}"
        else
          @chapterable_account_assignment = ChapterableAccountAssignment.new
          flash.now[:alert] = assignment.errors.full_messages.to_sentence
          render :new
        end
      end
    end

    def edit
      @account = Account.find(params.fetch(:account_id))
      @chapterable_account_assignment = @account.current_chapterable_assignment
    end

    def update
      @account = Account.find(params.fetch(:account_id))
      @chapterable_account_assignment = ChapterableAccountAssignment.find(params.fetch(:id))
      chapterable_type = chapterable_account_assignment_params.fetch(:chapterable_type)
      chapterable_id = chapterable_account_assignment_params.fetch(:chapter_id).presence ||
        chapterable_account_assignment_params.fetch(:club_id).presence

      if chapterable_id.present?
        if @chapterable_account_assignment.update(
          chapterable_id: chapterable_id,
          chapterable_type: chapterable_type.capitalize
        )
          @account.update(no_chapterable_selected: nil)

          redirect_to admin_participant_path(@account),
            success: "Successfully updated #{@account.full_name}'s #{chapterable_type.downcase} assignment"
        else
          flash.now[:alert] = @chapterable_account_assignment.errors.full_messages.to_sentence
          render :edit
        end
      else
        @chapterable_account_assignment.delete

        if @account.is_a_mentor? || @account.is_a_student?
          @account.update(no_chapterable_selected: true)
        end
        redirect_to admin_participant_path(@account),
          success: "Successfully removed #{@account.full_name}'s #{chapterable_type.downcase} assignment"
      end
    end

    private

    def chapterable_account_assignment_params
      params.require(:chapterable_account_assignment).permit(:chapter_id, :club_id, :chapterable_type)
    end

    def get_chapterables
      @chapters = Chapter.all.order(:country, :organization_name)
      @clubs = Club.all.order(:country, :name)
    end
  end
end
