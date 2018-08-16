module Registration
  class ProfileChoicesController < RegistrationController
    def create
      attempt = SignupAttempt.wizard.find_by!(
        wizard_token: profile_choice_params[:wizard_token]
      )

      attempt.update!({
        profile_choice:  profile_choice_params[:choice],
      })

      render json: SignupAttemptSerializer.new(attempt).serialized_json
    end

    private
    def profile_choice_params
      params.require(:profile_choice).permit(:choice, :wizard_token)
    end
  end
end