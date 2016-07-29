module Student
  class TeamMemberInvitesController < StudentController
    include TeamMemberInviteController

    private
    def account_type
      "student"
    end

    def current_account
      current_student
    end
  end
end
