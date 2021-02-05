module HandleGeocoderSearch
  def self.call(options)
    db_record = options[:db_record]
    controller = options[:controller]
    geocoder_query = GeocoderQuery.new(options[:query])

    if geocoder_query.country_code == 'PS'
      handle_palestine_search(db_record, geocoder_query, controller)
    else
      handle_search(db_record, geocoder_query, controller)
    end
  end

  private
  def self.handle_search(db_record, geocoder_query, controller)
    geocoded_results = GeocodedResults.new(
      search_geocoder(geocoder_query),
      geocoder_query
    )


    results = handle_possible_insert_of_palestine_multi_result(geocoded_results)

    if results.one?
      handle_one_result(db_record, results.first, controller)
    elsif results.many?
      return { results: results }, :multiple_choices
    elsif results.none?
      return {}, :not_found
    end
  end

  def self.handle_possible_insert_of_palestine_multi_result(geocoded_results)
    return geocoded_results if geocoded_results.many? || geocoded_results.none?

    if geocoded_results.first.country.downcase == "israel"
      palestine_copy = geocoded_results.first.dup
      palestine_copy.id = SecureRandom.hex(4)
      palestine_copy.state = palestine_copy.state_code = nil
      palestine_copy.country = "Palestine, State of"

      geocoded_results.to_a + [palestine_copy]
    else
      geocoded_results
    end
  end

  def self.handle_palestine_search(db_record, geocoder_query, controller)
    object = OpenStruct.new(
      city: geocoder_query.city,
      state: geocoder_query.state,
      country: "State of Palestine",
      country_code: "PS",
      latitude: 30,
      longitude: 35,
    )

    geocoded = Geocoded.new(object)

    geocode_db_record(db_record, geocoded, controller)

    return { results: [geocoded] }, :ok
  end

  def self.search_geocoder(geocoder_query)
    query = String(geocoder_query)
    results = Geocoder.search(query, lookup: :google)

    if results.none? && !Rails.env.test?
      Geocoder.search(query, lookup: :bing)
    else
      results
    end
  end

  def self.handle_one_result(db_record, geocoded, controller)
    if geocoded.valid?
      geocode_db_record(db_record, geocoded, controller)
      status_code = :ok
    else
      status_code = :not_found
    end

    return { results: [Geocoded.new(db_record)] }, status_code
  end

  def self.geocode_db_record(db_record, geocoded, controller)
    return false unless db_record.present?
    db_record.assign_address_details(geocoded)
    Geocoding.perform(db_record, controller).with_save
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