module Registration
  class AccountsController < RegistrationController
    def create
      attempt = SignupAttempt.wizard.find_by!(
        wizard_token: account_params.fetch(:wizard_token)
      )

      account = Account.create!({
        email: account_params.fetch(:email),
        password: account_params.fetch(:email),

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
      })

      attempt.update!({ account_id: account.id })
      attempt.registered!

      remove_cookie(CookieNames::SIGNUP_TOKEN)

      render json: AccountSerializer.new(account).serialized_json
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