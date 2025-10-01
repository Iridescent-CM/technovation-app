module Student
  class ScoresOverviewController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet
  end
end
