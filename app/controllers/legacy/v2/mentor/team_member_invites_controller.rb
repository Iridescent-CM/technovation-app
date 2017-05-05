module Mentor
  class TeamMemberInvitesController < MentorController
    include TeamMemberInviteController

    private
    def account_type
      "mentor"
    end

    def current_profile
      current_mentor
    end
  end
end
