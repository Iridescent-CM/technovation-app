module Student
  class TeamSubmissionsController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationSet
    include TeamSubmissionController

    before_action :require_onboarded,
                  :require_current_team
  end
end
