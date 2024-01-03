module Mentor
  class TeamSubmissionsController < MentorController
    include TeamSubmissionController

    before_action :require_onboarded

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
