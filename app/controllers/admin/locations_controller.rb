module Admin
  class LocationsController < AdminController
    def update
      if account_id = params.fetch(:account_id) { false }
        record = Account.find(params.fetch(:account_id))
      else
        record = Team.find(params.fetch(:team_id))
      end

      data, status = HandleGeocoderSearch.(record, location_params)

      render json: data, status: status
    end

    private
    def location_params
      params.require(:admin_location)
        .permit(:city, :state_code, :country_code)
    end
  end
end