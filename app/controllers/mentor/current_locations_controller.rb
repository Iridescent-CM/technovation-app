module Mentor
  class CurrentLocationsController < MentorController
    def show
      if team_id = params.fetch(:team_id) { false }
        team = current_mentor.current_teams.find(team_id)

        state = FriendlySubregion.(team, prefix: false)
        state_code = FriendlySubregion.(team, {
          prefix: false,
          short_code: true
        })

        friendly_country = FriendlyCountry.new(team)

        render json: {
          city: team.city,
          state: state,
          state_code: state_code,
          country: friendly_country.country_name,
          country_code: friendly_country.as_short_code,
        }
      else
        state = FriendlySubregion.(current_account, prefix: false)
        state_code = FriendlySubregion.(current_account, {
          prefix: false,
          short_code: true
        })

        friendly_country = FriendlyCountry.new(current_account)

        render json: {
          city: current_account.city,
          state: state,
          state_code: state_code,
          country: friendly_country.country_name,
          country_code: friendly_country.as_short_code,
        }
      end
    end
  end
end