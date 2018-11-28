module Registration
  class CurrentLocationsController < RegistrationController
    def show
      geocoded = {}

      if current_attempt.valid_coordinates?
        geocoded = Geocoded.new(current_attempt)
      end

      render json: geocoded
    end

    private
    def current_attempt
      if token = get_cookie(CookieNames::SIGNUP_TOKEN)
        @current_attempt ||= SignupAttempt.wizard.find_by(wizard_token: token)
      end

      @current_attempt ||= ::NullSignupAttempt.new
    end
  end
end
