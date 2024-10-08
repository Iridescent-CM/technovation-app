module Admin
  class ChapterAccountAssignmentsController < AdminController
    def new
      @account = Account.find(params.fetch(:account_id))
      @chapters = Chapter.all.order(organization_name: :asc)
      @chapter_account_assignment = ChapterAccountAssignment.new
    end

    def create
      account = Account.find(params.fetch(:account_id))

      account.chapter_assignments.where(season: Season.current.year).delete_all

      if chapter_account_assignment_params.fetch(:chapter_id).present?
        account.chapter_assignments.create(
          profile: account.current_profile,
          chapter_id: chapter_account_assignment_params.fetch(:chapter_id),
          season: Season.current.year,
          primary: true
        )
      end

      redirect_to admin_participant_path(account),
        success: "Successfully assigned #{account.full_name} to a new chapter"
    end

    private

    def chapter_account_assignment_params
      params.require(:chapter_account_assignment).permit(:chapter_id)
    end
  end
end
