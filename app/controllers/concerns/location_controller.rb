module LocationController
  extend ActiveSupport::Concern

  def update
    data, status = HandleGeocoderSearch.({
      db_record: db_record,
      query: location_params
    })

    StoreLocation.(
      coordinates: db_record.coordinates,
      account: db_record,
      context: self
    )

    render json: data, status: status
  end

  private
  def location_params
    params.require("#{current_scope}_location")
      .permit(:city, :state, :country)
  end

  def db_record
    begin
      current_account.authenticated? ?
        current_account :
        raise("try current_attempt")
    rescue
      begin
        current_attempt
      rescue
        false
      end
    end
  end
end