module Student
  class CurrentLocationsController < StudentController
    def show
      if params.fetch(:team_id) { false }
        render json: {
          city: current_team.city,
          state_code: current_team.state_province,
          country_code: current_team.country,
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