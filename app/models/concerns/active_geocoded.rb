module ActiveGeocoded
  extend ActiveSupport::Concern

  included do
    geocoded_by :address_details
    reverse_geocoded_by :latitude, :longitude do |account, results|
      account.update_address_details_from_reverse_geocoding(results)
    end
  end

  def latitude
    Float(self[:latitude] || 0)
  end

  def longitude
    Float(self[:longitude] || 0)
  end

  def coordinates
    [latitude, longitude]
  end

  def valid_coordinates?
    coordinates.length == 2 &&
      coordinates.all? { |c| !c.nil? && String(c) != "0.0" }
  end

  def valid_address?
    !city.blank? && !country_code.blank?
  end

  def primary_location
    [
      city,
      state_code,
      country_code,
    ].reject(&:blank?).join(', ')
  end
  alias :address_details :primary_location
  alias :location :primary_location

  def state_province
    self[:state_province] || self[:state_code]
  end
  alias :state_code :state_province

  def state
    FriendlySubregion.(self, prefix: false)
  end

  def country_code
    self[:country_code] || self[:country]
  end

  def country
    if valid_address?
      me = OpenStruct.new(address_details: [city, state_code, country_code].join(", "))
      FriendlyCountry.new(me).country_name
    else
      super rescue country_code
    end
  end

  def state_code=(code)
    super rescue self.state_province = code
  end

  def country_code=(code)
    super rescue self.country = code
  end

  def update_address_details_from_reverse_geocoding(results)
    return false if results.none?

    result = results.first

    self.city = result.city
    self.state_code = result.state_code

    address_details = [
      result.city,
      result.state,
      result.country,
    ].reject(&:blank?).join(", ")

    geo = OpenStruct.new(address_details: address_details)

    self.country_code = FriendlyCountry.new(geo).country_code
  end
end