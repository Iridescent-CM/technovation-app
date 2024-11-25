module ChapterAmbassador
  class ChapterAdminController < ChapterAmbassadorController
    def show
      trackable_user_ids = Account.current
        .not_staff
        .in_region(current_ambassador)
        .pluck(:id) - [current_ambassador.account_id]

      trackable_team_ids = Team.current
        .in_region(current_ambassador)
        .pluck(:id)

      @recent_activities = PublicActivity::Activity.distinct
        .where("(activities.trackable_id IN (?) AND " \
               "activities.trackable_type = ?) OR " \
               "(activities.trackable_id IN (?) AND " \
               "activities.trackable_type = ?)",
          trackable_user_ids,
          "Account",
          trackable_team_ids,
          "Team")
        .order("created_at desc")
        .first(20)

      @top_inactive_mentors = Account.in_region(current_ambassador)
        .not_staff
        .inactive_mentors
        .limit(3)

      @top_inactive_students = Account.in_region(current_ambassador)
        .not_staff
        .inactive_students
        .limit(3)

      @top_inactive_teams = Team.in_region(current_ambassador)
        .not_staff
        .inactive
        .limit(3)

      flash.now[:alert] = "Note: This page may not show accurate data. We're working on updating it, please refer to the participants page for accurate numbers."
    end
  end
end
