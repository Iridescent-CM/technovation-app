module LocationController
  extend ActiveSupport::Concern

  included do
    skip_before_action :store_location
  end

  def create
    db_record.city = location_params.fetch(:city)
    db_record.state_province = location_params.fetch(:state)
    db_record.country = location_params.fetch(:country)

    Geocoding.perform(db_record).with_save

    StoreLocation.(
      coordinates: db_record.coordinates,
      account: db_record,
      context: self
    )

    head 200
  end

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