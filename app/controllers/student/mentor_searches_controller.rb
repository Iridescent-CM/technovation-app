module Student
  class MentorSearchesController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet
    include ::MentorSearchesController
  end
end
