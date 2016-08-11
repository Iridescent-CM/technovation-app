module Student
  class SignupsController < ApplicationController
    include SignupController

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

    def after_signup_path
      if invite = TeamMemberInvite.pending.find_by(invitee_email: @student.email)
        student_team_member_invite_path(invite.invite_token)
      else
        super
      end
    end
  end
end
