module Registration
  class LocationsController < RegistrationController
    def update
      result = Geocoder.search(get_cookie(CookieNames::IP_GEOLOCATION)).first
      geocoded = Geocoded.new(result)
      render json: { results: [geocoded] }
    end
  end
end