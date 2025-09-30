module Student
  class TeamCreationController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet
  end
end
