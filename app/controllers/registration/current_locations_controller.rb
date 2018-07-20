module Registration
  class CurrentLocationsController < RegistrationController
    def show
      result = Geocoder.search(get_cookie(CookieNames::IP_GEOLOCATION)).first
      geocoded = Geocoded.new(result)
      render json: geocoded
    end
  end
end