module Mentor
  class RegionalPitchEventSelectionsController < MentorController
    def new
      @teams = current_mentor.teams.current
    end
  end
end
