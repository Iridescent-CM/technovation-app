module Registration
  class TermsAgreementsController < RegistrationController
    def create
      attempt = SignupAttempt.wizard.find_or_initialize_by(
        wizard_token: terms_agreement_params[:wizard_token]
      )

      attempt.set_terms_agreed(terms_agreement_params[:terms_agreed])

      if !attempt.country_code
        if result = Geocoder.search(get_cookie(CookieNames::IP_GEOLOCATION)['coordinates']).first
          geocoded = Geocoded.new(result)
          attempt.update({
            city: geocoded.city,
            state_code: geocoded.state_code,
            country_code: geocoded.country_code,
            latitude: geocoded.latitude,
            longitude: geocoded.longitude,
          })
        end
      end

      set_cookie(CookieNames::SIGNUP_TOKEN, attempt.wizard_token)

      render json: SignupAttemptSerializer.new(attempt).serialized_json
    end

    private
    def terms_agreement_params
      params.require(:terms_agreement).permit(:terms_agreed, :wizard_token)
    end
  end
end