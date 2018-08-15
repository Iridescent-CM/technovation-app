module Student
  class CurrentLocationsController < StudentController
    def show
      if params.fetch(:team_id) { false }
        state = FriendlySubregion.(
          OpenStruct.new(
            state_province: current_team.state_province,
            country: current_team.country
          ),
          prefix: false,
        )

        country = FriendlyCountry.(
          OpenStruct.new(country: current_team.country),
          prefix: false,
        )

        render json: {
          city: current_team.city,
          state: state,
          state_code: current_team.state_province,
          country: country,
          country_code: current_team.country,
        }
      else
        state = FriendlySubregion.(
          OpenStruct.new(
            state_province: current_account.state_province,
            country: current_account.country
          ),
          prefix: false,
        )

        country = FriendlyCountry.(
          OpenStruct.new(country: current_account.country),
          prefix: false,
        )

        render json: {
          city: current_account.city,
          state: state,
          state_code: current_account.state_province,
          country: country,
          country_code: current_account.country,
        }
      end
    end
  end
end