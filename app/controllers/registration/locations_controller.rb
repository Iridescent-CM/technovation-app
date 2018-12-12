module Registration
  class LocationsController < RegistrationController
    include LocationController

    def create
      attempt = SignupAttempt.wizard.find_by!(
        wizard_token: custom_location_params[:token]
      )

      render json: SignupAttemptSerializer.new(attempt).serialized_json
    end

    private
    def custom_location_params
      params.require(:registration_location).permit(:city, :state, :country, :token)
    end

    def current_attempt
      if token = get_cookie(CookieNames::SIGNUP_TOKEN)
        @current_attempt ||= SignupAttempt.wizard.find_by(wizard_token: token)
      else
        ::NullSignupAttempt.new
      end
    end
  end
end