module LocationController
  extend ActiveSupport::Concern

  def update
    data, status = HandleGeocoderSearch.({
      db_record: db_record,
      query: location_params
    })

    render json: data, status: status
  end

  private
  def location_params
    params.require("#{current_scope}_location")
      .permit(:city, :state_code, :country_code)
  end

  def db_record
    if respond_to?(:current_account)
      current_account
    end
  end
end