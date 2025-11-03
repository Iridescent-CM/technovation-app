module Mentor
  class BackgroundChecksController < MentorController
    include BackgroundCheckController
    include BackgroundCheckInvitationController

    private

    def current_profile
      current_mentor
    end
  end
end
