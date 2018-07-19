module Mentor
  class LocationsController < MentorController
    def update
      if team_id = params.fetch(:team_id) { false }
        record = current_mentor.current_teams.find(team_id)
      else
        record = current_account
      end

      data, status = HandleGeocoderSearch.(record, location_params)

      render json: data, status: status
    end

    private
    def location_params
      params.require(:mentor_location)
        .permit(:city, :state_code, :country_code)
    end
  end
end