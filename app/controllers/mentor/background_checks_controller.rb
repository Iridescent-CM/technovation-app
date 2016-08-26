module Mentor
  class BackgroundChecksController < MentorController
    include BackgroundCheckController

    private
    def current_account
      current_mentor
    end

    def current_profile
      current_mentor.mentor_profile
    end
  end
end
