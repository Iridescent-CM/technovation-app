module HandleGeocoderSearch
  def self.call(db_record, params)
    if params[:country_code] == 'PS'
      handle_palestine_search(db_record, params)
    else
      handle_search(db_record, params)
    end
  end

  private
  def self.handle_search(db_record, params)
    results = search_geocoder(params)

    if results.one?
      handle_one_result(db_record, results.first, params)
    elsif results.many?
      return { results: results.map { |r| Geocoded.new(r) } }, :multiple_choices
    elsif results.none?
      return {}, :not_found
    end
  end

  def self.handle_palestine_search(db_record, params)
    object = OpenStruct.new(
      city: params[:city],
      state_code: params[:state_code],
      country_code: params[:country_code],
      latitude: 30,
      longitude: 35,
    )

    geocoded = Geocoded.new(object)

    geocode_db_record(db_record, geocoded)

    return { results: [geocoded] }, :ok
  end

  def self.search_geocoder(params)
    query = params.values.join(", ")
    results = Geocoder.search(query)

    results.none? ?
      Geocoder.search(query, lookup: :bing) :
      results
  end

  def self.handle_one_result(db_record, result, params)
    geocoded = Geocoded.new(result)

    if geocoded.valid?
      geocode_db_record(db_record, geocoded)
      status_code = :ok
    else
      status_code = :not_found
    end

    return { results: [geocoded] }, status_code
  end

  def self.geocode_db_record(db_record, geocoded)
    db_record.city = geocoded.city
    db_record.state_province = geocoded.state_code
    db_record.country = geocoded.country_code

    Geocoding.perform(db_record).with_save
  end
end