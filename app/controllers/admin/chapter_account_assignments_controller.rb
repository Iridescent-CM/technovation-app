module Admin
  class ChapterAccountAssignmentsController < AdminController
    def new
      @account = Account.find(params.fetch(:account_id))
      @chapters = Chapter.all.order(organization_name: :asc)
      @chapter_account_assignment = ChapterAccountAssignment.new
    end

    def create
      account = Account.find(params.fetch(:account_id))

      account
        .current_chapterable_assignments
        .where(primary: true)
        .delete_all

      if chapter_account_assignment_params.fetch(:chapter_id).present?
        account.chapterable_assignments.create(
          profile: account.chapter_ambassador_profile.presence ||
            account.mentor_profile.presence ||
            account.student_profile,
          chapterable_id: chapter_account_assignment_params.fetch(:chapter_id),
          chapterable_type: "Chapter",
          season: Season.current.year,
          primary: true
        )

        account.update(no_chapter_selected: nil)
      end

      redirect_to admin_participant_path(account),
        success: "Successfully assigned #{account.full_name} to a new chapter"
    end

    def edit
      @account = Account.find(params.fetch(:account_id))
      @chapters = Chapter.all.order(organization_name: :asc)
      @chapter_account_assignment = @account.current_chapterable_assignment
    end

    def update
      account = Account.find(params.fetch(:account_id))
      chapter_account_assignment = ChapterAccountAssignment.find(params.fetch(:id))

      if chapter_account_assignment_params.fetch(:chapter_id).present?
        chapter_account_assignment.update(
          chapterable_id: chapter_account_assignment_params.fetch(:chapter_id),
          chapterable_type: "Chapter"
        )

        account.update(no_chapter_selected: nil)
      else
        chapter_account_assignment.delete

        if account.is_a_mentor? || account.is_a_student?
          account.update(no_chapter_selected: true)
        end
      end

      redirect_to admin_participant_path(account),
        success: "Successfully updated #{account.full_name}'s chapter assignment"
    end

    private

    def chapter_account_assignment_params
      params.require(:chapter_account_assignment).permit(:chapter_id)
    end
  end
end
