module Mentor
  class CurrentLocationsController < MentorController
    def show
      if team_id = params.fetch(:team_id) { false }
        team = current_mentor.current_teams.find(team_id)

        state = FriendlySubregion.(
          OpenStruct.new(
            state_province: team.state_province,
            country: team.country
          ),
          prefix: false,
        )

        country = FriendlyCountry.(
          OpenStruct.new(country: team.country),
          prefix: false,
        )

        render json: {
          city: team.city,
          state: state,
          state_code: team.state_province,
          country: country,
          country_code: team.country,
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