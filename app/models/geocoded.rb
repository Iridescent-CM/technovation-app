class Geocoded
  attr_accessor :id, :city, :state_code, :state, :country, :country_code,
    :latitude, :longitude

  def initialize(geocoder_result, query = nil)
    @id = SecureRandom.hex(4)
    @state_code = geocoder_result.state_code
    @state = geocoder_result.state
    @latitude = geocoder_result.latitude
    @longitude = geocoder_result.longitude
    set_city(geocoder_result, query)
    set_country(geocoder_result)
  end

  def valid?
    !city.blank? && !country_code.blank?
  end

  private

  def set_city(geocoder_result, query)
    @city = geocoder_result.city

    if @city.blank? && geocoder_result.respond_to?(:data)
      @city = geocoder_result.data.fetch("address") { {} }["adminDistrict2"]
    end

    if @city.blank? && query && query.city
      @city = query.city
    end
  end

  def set_country(geocoder_result)
    code = geocoder_result.country_code
    country_result = Country.find_country_by_name(code) ||
      Country.find_country_by_alpha3(code) ||
      Country.find_country_by_alpha2(code)

    @country_code = country_result && country_result.alpha2
    @country = country_result && country_result.name

    if suggest_palestine?(geocoder_result)
      @country_code = "PS"
      @country = "State of Palestine"
    end

    @country_code ||= geocoder_result.country_code
    @country ||= geocoder_result.country
  end

  def suggest_palestine?(result)
    return false unless result.country.blank? || (result.country || "").match?(/west bank/i)

    lat = Float(result.latitude)
    lng = Float(result.longitude)

    bbox = {
      lng_west: 34.2675,
      lat_south: 29.4534,
      lng_east: 35.895,
      lat_north: 33.3356
    }

    lat > bbox[:lat_south] &&
      lat < bbox[:lat_north] &&
      lng < bbox[:lng_east] &&
      lng > bbox[:lng_west]
  end
end
