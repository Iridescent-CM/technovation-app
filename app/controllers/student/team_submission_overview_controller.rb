module Student
  class TeamSubmissionOverviewController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet
  end
end
