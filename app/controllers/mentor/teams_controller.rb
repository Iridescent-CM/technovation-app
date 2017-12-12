module Mentor
  class TeamsController < MentorController
    include TeamController

    private
    def current_profile
      current_mentor
    end
  end
end
