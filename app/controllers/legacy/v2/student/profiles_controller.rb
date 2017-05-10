module Legacy
  module V2
    module Student
      class ProfilesController < StudentController
        include Concerns::ProfileController

        def profile_params
          [
            :parent_guardian_email,
            :parent_guardian_name,
            :school_name,
          ]
        end

        private
        def account
          current_student
        end

        def edit_profile_path
          edit_student_profile_path
        end

        def account_param_root
          :student_profile
        end
      end
    end
  end
end
