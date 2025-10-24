module Student
  class TeamSearchController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet
  end
end
