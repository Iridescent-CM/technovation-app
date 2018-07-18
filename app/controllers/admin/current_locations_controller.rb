module Admin
  class CurrentLocationsController < AdminController
    def show
      if account_id = params.fetch(:account_id) { false }
        record = Account.find(account_id)
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