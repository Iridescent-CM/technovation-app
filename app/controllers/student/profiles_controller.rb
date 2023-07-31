module Student
  class ProfilesController < StudentController
    include ProfileController

    def show
      @parental_consent = current_student.parental_consent
    end

    def profile_params
      [
        :parent_guardian_email,
        :parent_guardian_name,
        :school_name
      ]
    end

    private

    def profile
      current_student
    end

    def edit_profile_path
      edit_student_profile_path
    end

    def profile_param_root
      :student_profile
    end
  end
end
