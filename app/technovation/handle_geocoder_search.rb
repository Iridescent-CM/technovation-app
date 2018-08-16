module HandleGeocoderSearch
  def self.call(options)
    db_record = options[:db_record]
    geocoder_query = GeocoderQuery.new(options[:query])

    if geocoder_query.country_code == 'PS'
      handle_palestine_search(db_record, geocoder_query)
    else
      handle_search(db_record, geocoder_query)
    end
  end

  private
  def self.handle_search(db_record, geocoder_query)
    results = GeocodedResults.new(search_geocoder(geocoder_query), geocoder_query)

    if results.one?
      handle_one_result(db_record, results.first)
    elsif results.many?
      return { results: results }, :multiple_choices
    elsif results.none?
      return {}, :not_found
    end
  end

  def self.handle_palestine_search(db_record, geocoder_query)
    object = OpenStruct.new(
      city: geocoder_query.city,
      state: geocoder_query.state,
      country: "State of Palestine",
      country_code: "PS",
      latitude: 30,
      longitude: 35,
    )

    geocoded = Geocoded.new(object)

    geocode_db_record(db_record, geocoded)

    return { results: [geocoded] }, :ok
  end

  def self.search_geocoder(geocoder_query)
    query = String(geocoder_query)
    results = Geocoder.search(query)

    if results.none? && !Rails.env.test?
      Geocoder.search(query, lookup: :bing)
    else
      results
    end
  end

  def self.handle_one_result(db_record, geocoded)
    if geocoded.valid?
      geocode_db_record(db_record, geocoded)
      status_code = :ok
    else
      status_code = :not_found
    end

    return { results: [geocoded] }, status_code
  end

  def self.geocode_db_record(db_record, geocoded)
    return false if !db_record

    db_record.city = geocoded.city
    db_record.state_province = geocoded.state_code
    db_record.country = geocoded.country_code

    Geocoding.perform(db_record).with_save
  end

  class GeocodedResults
    include Enumerable

    def initialize(geocoder_results, query = nil)
      @results = geocoder_results.map { |result|
        geocoded = Geocoded.new(result, query)

        if !geocoded.valid?
          data = (result.data['geocodePoints'] || [{}]).first['coordinates']
          data ||= result.data.fetch('geometry') { { 'location' => {} } }['location'].values

          if my_result = Geocoder.search(data, lookup: :google).first
            geocoded = Geocoded.new(my_result)
          else
            geocoded
          end
        end

        geocoded
      }.uniq { |geocoded|
        [geocoded.city, geocoded.state_code, geocoded.country_code]
      }
    end

    def each(&block)
      @results.each(&block)
    end
  end

  class GeocoderQuery
    attr_reader :city, :state, :country, :country_code

    def initialize(params)
      @city = params[:city]
      @state = params[:state]
      @country = params[:country]
      @country_code = get_country_code
    end

    def to_s
      [city, state, country_code].compact.join(', ')
    end

    private
    def get_country_code
      if country && country.match(/palestine/i)
        "PS"
      else
        country_result = Country.find_country_by_name(country) ||
                          Country.find_country_by_alpha3(country) ||
                            Country.find_country_by_alpha2(country)
        country_result && country_result.alpha2
      end
    end
  end
end