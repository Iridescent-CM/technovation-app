module Mentor
  class BackgroundChecksController < MentorController
    include BackgroundCheckController
    include BackgroundCheckInvitationController

    layout "mentor_rebrand"

    private

    def current_profile
      current_mentor
    end
  end
end
