module Student
  class TeamSubmissionsController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet
    include TeamSubmissionController

    before_action :require_onboarded,
      :require_current_team
  end
end
