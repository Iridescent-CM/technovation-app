module HandleGeocoderSearch
  def self.call(params, account)
    results = search_geocoder(params)

    if results.one?
      handle_one_result(account, results.first, params)
    elsif results.many?
      return geocoded_results_json(results), :multiple_choices
    elsif results.none?
      return {}, :not_found
    end
  end

  private
  def self.search_geocoder(params)
    query = params.values.join(", ")
    results = Geocoder.search(query)

    results.none? ?
      Geocoder.search(query, lookup: :bing) :
      results
  end

  def self.geocoded_results_json(results)
    { results: results.map { |r| Geocoded.new(r) } }
  end

  def self.handle_one_result(account, result, params)
    geocoded = Geocoded.new(result)

    if !geocoded.valid?
      status_code = :not_found
    elsif !geocoded.match?(params)
      status_code = :multiple_choices
    else
      account.city = geocoded.city
      account.state_province = geocoded.state_code
      account.country = geocoded.country_code

      Geocoding.perform(account).with_save

      status_code = :ok
    end

    return { results: [geocoded] }, status_code
  end
end

class Geocoded
  attr_reader :id, :city, :state_code, :country, :country_code

  def initialize(geocoder_result)
    @id = SecureRandom.hex(4)

    @city = geocoder_result.city

    if @city.blank?
      @city = geocoder_result.data.fetch("address") { {} }["adminDistrict2"]
    end

    @state_code = geocoder_result.state_code

    code = geocoder_result.country_code
    country_result = Country.find_country_by_name(code) ||
                      Country.find_country_by_alpha3(code) ||
                        Country.find_country_by_alpha2(code)

    @country_code = country_result && country_result.alpha2
    @country = country_result.name

    @country_code = "PS" if maybe_palestine?(geocoder_result)
  end

  def match?(other)
    hsh = other.to_h

    (city || "").downcase == hsh["city"].downcase &&
      (state_code || "").downcase == hsh["state_code"].downcase &&
        (country_code || "").downcase == hsh["country_code"].downcase
  end

  def valid?
    !city.blank? && !country.blank?
  end

  private
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

    lat > bbox[:lat_south] and
      lat < bbox[:lat_north] and
        lng < bbox[:lng_east] and
          lng > bbox[:lng_west]
  end
end