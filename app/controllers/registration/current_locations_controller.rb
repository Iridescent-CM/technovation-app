module Registration
  class CurrentLocationsController < RegistrationController
    def show
      if current_attempt.valid_coordinates?
        geocoded = Geocoded.new(current_attempt)
      elsif result = Geocoder.search(CookiedCoordinates.get(self)).first
        geocoded = Geocoded.new(result)
      else
        StoreLocation.(
          ip_address: request.remote_ip,
          context: self,
        )
        result = Geocoder.search(CookiedCoordinates.get(self)).first
        geocoded = Geocoded.new(result)
      end

      render json: geocoded
    end

    private
    def current_attempt
      if token = get_cookie(CookieNames::SIGNUP_TOKEN)
        @current_attempt ||= SignupAttempt.wizard.find_by(wizard_token: token)
      else
        ::NullSignupAttempt.new
      end
    end
  end
end
