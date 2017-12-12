module Mentor
  class TeamsController < MentorController
    include TeamController

    def index
      @current_teams = current_mentor.teams.current
    end

    private
    def current_profile
      current_mentor
    end
  end
end
