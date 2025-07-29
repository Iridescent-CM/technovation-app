module Ambassador
  class ChapterableAccountAssignmentsController < AmbassadorController
    def create
      account = Account.find(params.fetch(:account_id))

      account
        .chapterable_assignments
        .where(season: Season.current.year, primary: true)
        .delete_all

      account.chapterable_assignments.create(
        profile: account.mentor_profile.presence || account.student_profile,
        chapterable_id: current_ambassador.current_chapterable.id,
        chapterable_type: current_ambassador.chapterable_type.capitalize,
        season: Season.current.year,
        primary: true,
        assignment_by: current_account
      )

      account.update(no_chapterable_selected: nil)

      if current_ambassador.chapter_ambassador?
        redirect_to chapter_ambassador_unaffiliated_participants_path,
          success: "Successfully assigned #{account.full_name} to a your chapter"
      else
        redirect_to club_ambassador_unaffiliated_participants_path,
          success: "Successfully assigned #{account.full_name} to a your club"
      end
    end
  end
end
