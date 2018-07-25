module Registration
  class TermsAgreementsController < RegistrationController
    def create
      attempt = SignupAttempt.wizard.find_or_initialize_by(
        wizard_token: terms_agreement_params[:wizard_token]
      )

      attempt.set_terms_agreed(terms_agreement_params[:terms_agreed])

      set_cookie(CookieNames::SIGNUP_TOKEN, attempt.wizard_token)

      render json: SignupAttemptSerializer.new(attempt).serialized_json
    end

    private
    def terms_agreement_params
      params.require(:terms_agreement).permit(:terms_agreed, :wizard_token)
    end
  end
end