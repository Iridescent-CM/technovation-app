module Mentor
  class LocationsController < MentorController
    include LocationController

    private

    def db_record
      @db_record ||= if team_id = params.fetch(:team_id) { false }
        current_mentor.current_teams.find(team_id)
      else
        current_account
      end
    end
  end
end
