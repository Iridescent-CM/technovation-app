module ActiveGeocoded
  extend ActiveSupport::Concern

  included do
    geocoded_by :address_details
    reverse_geocoded_by :latitude, :longitude do |account, results|
      account.update_address_details_from_reverse_geocoding(results)
    end

    before_validation :fix_state_country_formatting
  end

  def detect_location_changes?
    detect_city_changes? ||
      detect_country_changes? ||
      detect_country_code_changes?
  end

  def detect_city_changes?
    (saved_change_to_city? || city_changed?) && !city_was.blank?
  end

  def detect_country_changes?
    respond_to?(:saved_change_to_country?) &&
      (saved_change_to_country? || country_changed?) &&
      !country_was.blank?
  end

  def detect_country_code_changes?
    respond_to?(:saved_change_to_country_code?) &&
      (saved_change_to_country_code? || country_code_changed?) &&
      !country_code_was.blank?
  end

  def fix_state_country_formatting
    if self[:country] && self[:country].length > 3
      self.country = FriendlyCountry.new(self).as_short_code
    end

    if self[:state_province] && self[:state_province].length > 4
      self.state_province = FriendlySubregion.call(self, short_code: true)
    end

    if self[:country_code] && self[:country_code].length > 3
      self.country_code = FriendlyCountry.new(self).as_short_code
    end

    if self[:state_code] && self[:state_code].length > 3
      self.state_code = FriendlySubregion.call(self, short_code: true)
    end
  end

  def fix_state_country_formatting_with_save
    fix_state_country_formatting
    save
  end

  def fix_state_country_formatting_with_save_without_callbacks
    columns = {}

    if self[:country] && self[:country].length > 3
      columns[:country] = FriendlyCountry.new(self).as_short_code
    end

    if self[:state_province] && self[:state_province].length > 4
      columns[:state_province] = FriendlySubregion.call(self, short_code: true)
    end

    if self[:country_code] && self[:country_code].length > 3
      columns[:country_code] = FriendlyCountry.new(self).as_short_code
    end

    if self[:state_code] && self[:state_code].length > 3
      columns[:state_code] = FriendlySubregion.call(self, short_code: true)
    end

    update_columns(columns)
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
  alias_method :coordinates_valid?, :valid_coordinates?

  def valid_address?
    !city.blank? && !country_code.blank?
  end

  def primary_location
    [
      city,
      state,
      country
    ].reject(&:blank?).join(", ")
  end
  alias_method :address_details, :primary_location
  alias_method :location, :primary_location

  def state_province
    self[:state_province] || self[:state_code]
  end
  alias_method :state_code, :state_province

  def state
    FriendlySubregion.call(self, prefix: false)
  end

  def country_code
    self[:country_code] || self[:country]
  end

  def country
    if valid_address?
      country = Carmen::Country.coded(country_code) ||
        Carmen::Country.named(country_code)

      state_for_country = country.subregions.coded(state_code) ||
        country.subregions.named(state_code)

      me = OpenStruct.new(address_details: [city, state_for_country, country].join(", "))
      FriendlyCountry.new(me).country_name
    else
      begin
        super
      rescue
        country_code
      end
    end
  end

  def state_code=(code)
    super
  rescue
    self.state_province = code
  end

  def country_code=(code)
    super
  rescue
    self.country = code
  end

  def update_address_details_from_reverse_geocoding(results)
    return false if results.none?

    result = results.first

    self.city = result.city
    self.state_code = result.state_code

    address_details = [
      result.city,
      result.state,
      result.country
    ].reject(&:blank?).join(", ")

    geo = OpenStruct.new(address_details: address_details)

    self.country_code = FriendlyCountry.new(geo).country_code
  end
end
