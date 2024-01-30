module Mentor
  class DashboardsController < MentorController
    include LocationStorageController

    def show
      @current_teams = current_mentor.teams.current.order("teams.name")
    end

    private

    def create_judge_mentor_on_dashboard
      return if current_session.authenticated?
      # Chapter ambassador/Admin Logged in as someone else

      if CreateMentorProfile.call(current_account)
        flash.now[:success] = t(
          "controllers.mentor.dashboards.show.mentor_profile_created"
        )
      end
    end
  end
end
