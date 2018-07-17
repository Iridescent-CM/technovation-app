module Student
  class LocationsController < StudentController
    def update
      data, status = HandleGeocoderSearch.(
        location_params,
        current_account,
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