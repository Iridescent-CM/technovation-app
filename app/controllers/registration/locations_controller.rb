module Registration
  class LocationsController < RegistrationController
    include LocationController

    def create
      attempt = SignupAttempt.wizard.find_by!(
        wizard_token: custom_location_params[:token]
      )

      country_param = (custom_location_params[:country] || "").strip
      country = Carmen::Country.named(country_param)
      country_code = country && country.code

      state_code = if country
        state_param = (custom_location_params[:state] || "").strip
        state = country.subregions.named(state_param)
        state ||= country.subregions.coded(state_param)
        state && state.code
      else
        nil
      end

      attempt.update!({
        city:         custom_location_params[:city],
        state_code:   state_code,
        country_code: country_code,
      })

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