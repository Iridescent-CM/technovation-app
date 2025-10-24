module Student
  class MentorSearchController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet
  end
end
