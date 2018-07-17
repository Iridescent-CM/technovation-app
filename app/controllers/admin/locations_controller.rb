module Admin
  class LocationsController < AdminController
    def update
      account = Account.find(params.fetch(:account_id))

      data, status = HandleGeocoderSearch.(
        location_params,
        account,
      )

      render json: data, status: status
    end

    private
    def location_params
      params.require(:admin_location)
        .permit(:city, :state_code, :country_code)
    end
  end
end