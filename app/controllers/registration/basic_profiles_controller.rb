module Registration
  class BasicProfilesController < RegistrationController
    def create
      attempt = SignupAttempt.wizard.find_by!(
        wizard_token: basic_profile_params[:wizard_token]
      )

      attempt.update!({
        first_name:          basic_profile_params[:first_name],
        last_name:           basic_profile_params[:last_name],
        gender_identity:     basic_profile_params[:gender_identity],
        school_company_name: basic_profile_params[:school_company_name],
        referred_by:         basic_profile_params[:referred_by],
        referred_by_other:   basic_profile_params[:referred_by_other],
      })

      render json: SignupAttemptSerializer.new(attempt).serialized_json
    end

    private
    def basic_profile_params
      params.require(:basic_profile).permit(
        :first_name,
        :last_name,
        :gender_identity,
        :school_company_name,
        :referred_by,
        :referred_by_other,
        :wizard_token,
      )
    end
  end
end