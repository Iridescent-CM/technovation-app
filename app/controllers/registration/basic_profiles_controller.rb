module Registration
  class BasicProfilesController < RegistrationController
    def create
      profile_params = basic_profile_params.dup

      attempt = SignupAttempt.wizard.find_by!(
        wizard_token: profile_params.delete(:wizard_token)
      )

      attempt.update!(profile_params)

      render json: SignupAttemptSerializer.new(attempt).serialized_json
    end

    private
    def basic_profile_params
      params.require(:basic_profile).permit(
        :first_name,
        :last_name,
        :gender_identity,
        :school_company_name,
        :job_title,
        :referred_by,
        :referred_by_other,
        :wizard_token,
        :mentor_type,
        :bio,
        expertise_ids: [],
      )
    end
  end
end