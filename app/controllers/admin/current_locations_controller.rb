module Admin
  class CurrentLocationsController < AdminController
    def show
      if params.fetch(:account_id) { false }
        record = Account.find(params.fetch(:account_id))
      else
        record = Team.find(params.fetch(:team_id))
      end

      render json: {
        city: record.city,
        state_code: record.state_province,
        country_code: record.country,
      }
    end
  end
end