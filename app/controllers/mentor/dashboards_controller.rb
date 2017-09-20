module Mentor
  class DashboardsController < MentorController
    def show
      @teams = current_mentor.teams.current.order("teams.name")
    end

    private
    def create_judge_mentor_on_dashboard
      if CreateMentorProfile.(current_account)
        flash.now[:success] = t(
          "controllers.mentor.dashboards.show.mentor_profile_created"
        )
      end
    end
  end
end
