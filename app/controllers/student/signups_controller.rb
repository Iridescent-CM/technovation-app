module Student
  class SignupsController < ApplicationController
    include Signup

    def before_save(student)
      student.student_profile.team_invite_token = cookies.fetch(:team_invite_token) { "" }
    end

    private
    def model_name
      "student"
    end

    def profile_params
      %i{
          is_in_secondary_school
          parent_guardian_email
          parent_guardian_name
          school_name
        }
    end
  end
end
