module Registration
  class CurrentLocationsController < RegistrationController
    def show
      result = Geocoder.search(get_cookie(CookieNames::IP_GEOLOCATION)['coordinates']).first
      geocoded = Geocoded.new(result)
      render json: geocoded
    end
  end
end