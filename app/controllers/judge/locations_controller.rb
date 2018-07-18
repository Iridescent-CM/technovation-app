module Judge
  class LocationsController < JudgeController
    def update
      data, status = HandleGeocoderSearch.(current_account, location_params)
      render json: data, status: status
    end

    private
    def location_params
      params.require(:judge_location)
        .permit(:city, :state_code, :country_code)
    end
  end
end