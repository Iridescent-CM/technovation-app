module Student
  class CurriculumController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet
  end
end
