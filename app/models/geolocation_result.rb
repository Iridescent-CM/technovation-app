class GeolocationResult
  attr_reader :selected, :city, :state, :country, :lat, :lng

  def initialize(geocoding_result, lat, lng)
    @selected = false

    @lat = lat
    @lng = lng

    if geocoding_result.country.blank? and inside_palestine_bbox?
      @country = "PS"
    else
      @country = geocoding_result.country_code
    end

    if geocoding_result.city.blank?
      @city = geocoding_result.data.fetch("address") { {} }["adminDistrict2"]
    else
      @city = geocoding_result.city
    end

    @state = geocoding_result.state_code
  end

  def ==(other)
    city == other.city &&
      state == other.state &&
        country == other.country
  end

  def incomplete?
    city.blank? ||
      state.blank? ||
        country.blank?
  end

  private
  def inside_palestine_bbox?
    return false if lat.blank? or lng.blank?

    test_lat = Float(lat)
    test_lng = Float(lng)

    bbox = {
      lng_west: 34.2675,
      lat_south: 29.4534,
      lng_east: 35.895,
      lat_north: 33.3356,
    }

    test_lat > bbox[:lat_south] and
      test_lat < bbox[:lat_north] and
        test_lng < bbox[:lng_east] and
          test_lng > bbox[:lng_west]
  end
end