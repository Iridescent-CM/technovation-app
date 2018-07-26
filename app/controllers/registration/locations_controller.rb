module Registration
  class LocationsController < RegistrationController
    def update
      data, status = HandleGeocoderSearch.(
        query: location_params
      )
      render json: data, status: status
    end

    private
    def location_params
      params.require(:registration_location)
        .permit(:city, :state, :country)
    end
  end
end