module Mentor
  class BackgroundChecksController < MentorController
    include BackgroundCheckController

    private
    def current_account
      current_mentor
    end
  end
end
