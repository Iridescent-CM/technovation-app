module Mentor
  class LocationsController < MentorController
    include LocationController

    def create
      current_account.city = location_params.fetch(:city)
      current_account.state_province = location_params.fetch(:state)
      current_account.country = location_params.fetch(:country)

      Geocoding.perform(current_account).with_save

      head 200
    end

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