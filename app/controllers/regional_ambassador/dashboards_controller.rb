module RegionalAmbassador
  class DashboardsController < RegionalAmbassadorController
    def show
      if current_ambassador.needs_intro_prompt?
        current_ambassador.regional_links.build

        unless params[:anchoring_to_info]
          redirect_to(
            regional_ambassador_dashboard_path(
              anchor: "!ra-info",
              anchoring_to_info: true,
            )
          ) and return
        end
      else
        trackable_user_ids = Account.current
          .not_staff
          .in_region(current_ambassador)
          .pluck(:id) - [current_ambassador.account_id]

        trackable_team_ids = Team.current
          .in_region(current_ambassador)
          .pluck(:id)

        @recent_activities = PublicActivity::Activity.distinct
          .where("(activities.trackable_id IN (?) AND " +
                 "activities.trackable_type = ?) OR " +
                 "(activities.trackable_id IN (?) AND " +
                 "activities.trackable_type = ?)",
            trackable_user_ids,
            "Account",
            trackable_team_ids,
            "Team"
          )
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

        @students = StudentProfile.current.in_region(current_ambassador)

        @mentors = Account.current.in_region(current_ambassador)
          .left_outer_joins(:mentor_profile)
          .where("mentor_profiles.id IS NOT NULL")
      end

      render "regional_ambassador/dashboards" +
        "/show_#{current_ambassador.status}"
    end
  end
end
