module Admin
  class ChapterableAccountAssignmentsController < AdminController
    def new
      @account = Account.find(params.fetch(:account_id))
      @chapterables = Club.all.order(:country, :name)
      @chapterable_account_assignment = ChapterableAccountAssignment.new
    end

    def create
      account = Account.find(params.fetch(:account_id))
      chapterable_type = chapterable_account_assignment_params.fetch(:chapterable_type)

      account
        .current_chapterable_assignments
        .where(primary: true)
        .delete_all

      if chapterable_account_assignment_params.fetch(:chapterable_id).present?
        account.chapterable_assignments.create(
          profile: account.chapter_ambassador_profile.presence ||
            account.club_ambassador_profile.presence ||
            account.mentor_profile.presence ||
            account.student_profile,
          chapterable_id: chapterable_account_assignment_params.fetch(:chapterable_id),
          chapterable_type: chapterable_type,
          season: Season.current.year,
          primary: true
        )

        account.update(no_chapterable_selected: nil)
        account.update(no_chapterables_available: nil)
      end

      redirect_to admin_participant_path(account),
        success: "Successfully assigned #{account.full_name} to a new #{chapterable_type}"
    end

    def edit
      @account = Account.find(params.fetch(:account_id))
      @chapterables = Club.all.order(:country, :name)
      @chapterable_account_assignment = @account.current_chapterable_assignment
    end

    def update
      account = Account.find(params.fetch(:account_id))
      chapterable_account_assignment = ChapterableAccountAssignment.find(params.fetch(:id))
      chapterable_type = chapterable_account_assignment_params.fetch(:chapterable_type)


      if chapterable_account_assignment_params.fetch(:chapterable_id).present?
        chapterable_account_assignment.update(
          chapterable_id: chapterable_account_assignment_params.fetch(:chapterable_id),
          chapterable_type: chapterable_type
        )

        account.update(no_chapterable_selected: nil)
      else
        chapterable_account_assignment.delete

        if account.is_a_mentor? || account.is_a_student?
          account.update(no_chapterable_selected: true)
        end
      end

      redirect_to admin_participant_path(account),
        success: "Successfully updated #{account.full_name}'s #{chapterable_type} assignment"
    end

    private

    def chapterable_account_assignment_params
      params.require(:chapterable_account_assignment).permit(:chapterable_id, :chapterable_type)
    end
  end
end