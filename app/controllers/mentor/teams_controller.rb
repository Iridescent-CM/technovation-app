module Mentor
  class TeamsController < MentorController
    include TeamController

    def index
      @teams = current_mentor.teams
    end

    private
    def current_account
      current_mentor
    end
  end
end
