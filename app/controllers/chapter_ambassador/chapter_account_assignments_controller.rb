module ChapterAmbassador
  class ChapterAccountAssignmentsController < ChapterAmbassadorController
    def create
      account = Account.find(params.fetch(:account_id))

      account
        .chapterable_assignments
        .where(season: Season.current.year, primary: true)
        .delete_all

      account.chapterable_assignments.create(
        profile: account.mentor_profile.presence || account.student_profile,
        chapterable_id: chapter_account_assignment_params.fetch(:chapter_id),
        chapterable_type: "Chapter",
        season: Season.current.year,
        primary: true
      )

      account.update(no_chapterable_selected: nil)

      redirect_to chapter_ambassador_unaffiliated_participants_path,
        success: "Successfully assigned #{account.full_name} to a your chapter"
    end

    private

    def chapter_account_assignment_params
      params.require(:chapter_account_assignment).permit(:chapter_id)
    end
  end
end
