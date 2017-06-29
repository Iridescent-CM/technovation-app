module Mentor
  class TeamMemberInvitesController < MentorController
    include TeamMemberInviteController

    private
    def current_profile
      current_mentor
    end
  end
end
