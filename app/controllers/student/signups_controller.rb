module Student
  class SignupsController < ::SignupsController
    private
    def model_name
      "student"
    end

    def profile_params
      %i{
          parent_guardian_email
          parent_guardian_name
          school_name
        }
    end
  end
end
