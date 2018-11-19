module Judge
  class CurrentLocationsController < JudgeController
    def show
      state = FriendlySubregion.(
        OpenStruct.new(
          state_province: current_account.state_province,
          country: current_account.country
        ),
        prefix: false,
      )

      country = FriendlyCountry.new(current_account).country_name

      render json: {
        city: current_account.city,
        state: state,
        state_code: current_account.state_province,
        country: country,
        country_code: current_account.country_code,
      }
    end
  end
end