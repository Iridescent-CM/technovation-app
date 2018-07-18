module Mentor
  class CurrentLocationsController < MentorController
    def show
      if team_id = params.fetch(:team_id) { false }
        team = current_mentor.current_teams.find(team_id)

        render json: {
          city: team.city,
          state_code: team.state_province,
          country_code: team.country,
        }
      else
        render json: {
          city: current_account.city,
          state_code: current_account.state_province,
          country_code: current_account.country,
        }
      end
    end
  end
end