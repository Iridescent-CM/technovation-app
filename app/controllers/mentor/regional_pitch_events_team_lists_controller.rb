module Mentor
  class RegionalPitchEventsTeamListsController < MentorController

    def show
      @current_teams = current_mentor.teams.current.order("teams.name")
    end
  end
end
