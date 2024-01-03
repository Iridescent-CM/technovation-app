module LocationController
  extend ActiveSupport::Concern

  def create
    db_record.city = location_params.fetch(:city)
    db_record.state_province = location_params.fetch(:state)
    db_record.country = location_params.fetch(:country)

    Geocoding.perform(db_record, self).with_save

    head 200
  end

  def update
    data, status = HandleGeocoderSearch.call({
      db_record: db_record,
      query: location_params,
      controller: self
    })

    render json: data, status: status
  end

  private

  def location_params
    params.require("#{current_scope}_location")
      .permit(:city, :state, :country, :token)
  end

  def db_record
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
