module Judge
  class CurrentLocationsController < JudgeController
    def show
      state = FriendlySubregion.call(current_account, prefix: false)
      state_code = FriendlySubregion.call(current_account, {
        prefix: false,
        short_code: true
      })

      friendly_country = FriendlyCountry.new(current_account)

      render json: {
        city: current_account.city,
        state: state,
        state_code: state_code,
        country: friendly_country.country_name,
        country_code: friendly_country.as_short_code
      }
    end
  end
end
