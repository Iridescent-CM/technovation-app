module Mentor
  class TeamsController < MentorController
    include TeamController

    def index
      @current_teams = current_mentor.teams.current
      @past_teams = current_mentor.teams.past
    end

    private
    def current_account
      current_mentor
    end
  end
end
