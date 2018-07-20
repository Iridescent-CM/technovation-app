class Geocoded
  attr_reader :id, :city, :state_code, :country, :country_code

  def initialize(geocoder_result)
    @id = SecureRandom.hex(4)
    @state_code = geocoder_result.state_code
    set_city(geocoder_result)
    set_country(geocoder_result)
  end

  def valid?
    !city.blank? && !country_code.blank?
  end

  private
  def set_city(geocoder_result)
    @city = geocoder_result.city

    if @city.blank?
      @city = geocoder_result.data.fetch("address") { {} }["adminDistrict2"]
    end
  end

  def set_country(geocoder_result)
    code = geocoder_result.country_code
    country_result = Country.find_country_by_name(code) ||
                      Country.find_country_by_alpha3(code) ||
                        Country.find_country_by_alpha2(code)

    @country_code = country_result && country_result.alpha2
    @country = country_result && country_result.name

    if maybe_palestine?(geocoder_result)
      @country_code = "PS"
      @country = "State of Palestine"
    end
  end

  def maybe_palestine?(result)
    return false unless result.country.blank?

    lat = Float(result.latitude)
    lng = Float(result.longitude)

    bbox = {
      lng_west: 34.2675,
      lat_south: 29.4534,
      lng_east: 35.895,
      lat_north: 33.3356,
    }

    lat > bbox[:lat_south] &&
      lat < bbox[:lat_north] &&
        lng < bbox[:lng_east] &&
          lng > bbox[:lng_west]
  end
end