module Registration
  class AccountsController < RegistrationController
    def create
      attempt = SignupAttempt.wizard.find_by!(
        wizard_token: account_params.fetch(:wizard_token)
      )

      account_attributes = {
        email: account_params.fetch(:email),
        password: account_params.fetch(:password),

        date_of_birth: Date.new(
          attempt.birth_year,
          attempt.birth_month,
          attempt.birth_day
        ),

        first_name: attempt.first_name,
        last_name: attempt.last_name,

        city: attempt.city,
        state_province: attempt.state_code,
        country: attempt.country_code,
        latitude: attempt.latitude,
        longitude: attempt.longitude,

        gender: attempt.gender_identity,

        referred_by: attempt.referred_by,
        referred_by_other: attempt.referred_by_other,

        terms_agreed_at: attempt.terms_agreed_at,
      }

      profile_name = "#{attempt.profile_choice}_profile"
      profile = profile_name.camelize.constantize.new(
        {
          school_company_name: attempt.school_company_name,
          job_title: attempt.job_title,
          mentor_type_ids: attempt.mentor_type_ids,
          expertise_ids: attempt.expertise_ids,
          bio: attempt.bio,
          account_attributes: account_attributes,
        }
      )

      if profile.save
        ProfileCreating.execute(profile, self)
      else
        render json: { errors: profile.errors }, status: :unprocessable_entity
      end
    end

    private
    def account_params
      params.require(:account).permit(
        :email,
        :password,
        :wizard_token,
      )
    end
  end
end
