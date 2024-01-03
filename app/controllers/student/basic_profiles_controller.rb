module Student
  class BasicProfilesController < StudentController
    include BasicProfileController

    with_profile :current_student

    with_params school_company_name: {
      rename: true,
      attribute_name: :school_name,
      method_name: :school_name
    }
  end
end
