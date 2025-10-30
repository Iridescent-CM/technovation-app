module Mentor
  class TeamsController < MentorController
    include TeamController
    before_action :require_onboarded

    def index
      @current_teams = current_mentor.teams.current.order("teams.name")
    end

    private

    def current_profile
      current_mentor
    end
  end
end
