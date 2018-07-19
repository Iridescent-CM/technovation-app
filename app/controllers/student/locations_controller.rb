module Student
  class LocationsController < StudentController
    def update
      data, status = HandleGeocoderSearch.(
        params.fetch(:team_id) { false } ? current_team : current_account,
        location_params,
      )
      render json: data, status: status
    end

    private
    def location_params
      params.require(:student_location)
        .permit(:city, :state_code, :country_code)
    end
  end
end