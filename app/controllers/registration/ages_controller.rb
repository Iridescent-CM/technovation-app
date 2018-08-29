module Registration
  class AgesController < RegistrationController
    def create
      attempt = SignupAttempt.wizard.find_by!(
        wizard_token: age_params[:wizard_token]
      )

      attempt.update!({
        birth_year:  age_params[:year],
        birth_month: age_params[:month],
        birth_day:   age_params[:day],
      })

      render json: SignupAttemptSerializer.new(attempt).serialized_json
    end

    private
    def age_params
      params.require(:birth_date).permit(:year, :month, :day, :wizard_token)
    end
  end
end