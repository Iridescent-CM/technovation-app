module Mentor
  class TeamSubmissionsController < MentorController
    include TeamSubmissionController

    before_action :require_onboarded

    def index
      @current_teams = current_mentor.teams.current.order("teams.name")
    end

    private

    def require_onboarded
      if current_mentor.onboarded?
        true
      else
        redirect_to mentor_dashboard_path,
          notice: t("controllers.application.onboarding_required")
      end
    end
  end
end
