module Admin
  class CurrentLocationsController < AdminController
    def show
      account = Account.find(params.fetch(:account_id))

      render json: {
        city: account.city,
        state_code: account.state_province,
        country_code: account.country,
      }
    end
  end
end