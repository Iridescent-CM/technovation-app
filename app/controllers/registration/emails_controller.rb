module Registration
  class EmailsController < RegistrationController
    def create
      attempt = SignupAttempt.wizard.find_by!(
        wizard_token: email_params[:wizard_token]
      )

      attempt.update!(email: email_params.fetch(:email))

      render json: SignupAttemptSerializer.new(attempt).serialized_json
    end

    private
    def email_params
      params.require(:email).permit(:email, :wizard_token)
    end
  end
end