module Student
  class LocationsController < StudentController
    def update
      data, status = HandleGeocoderSearch.(
        location_params,
        current_account,
      )
      render json: data, status: status
    end

    private
    def location_params
      params.require(:student_location)
        .permit(:city, :state_code, :country_code)
    end
  end

  module HandleGeocoderSearch
    def self.call(params, account)
      results = search_geocoder(params)

      if results.one?
        handle_one_result(results.first, params)
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

    def self.handle_one_result(result, params)
      geocoded = Geocoded.new(result)

      if !geocoded.match?(params)
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
    attr_reader :city, :state_code, :country_code

    def initialize(geocoder_result)
      @city = geocoder_result.city

      if @city.blank?
        @city = geocoder_result.data.fetch("address") { {} }["adminDistrict2"]
      end

      @state_code = geocoder_result.state_code
      @country_code = geocoder_result.country_code

      @country_code = "PS" if maybe_palestine?(geocoder_result)
    end

    def match?(other)
      hsh = other.to_h

      city.downcase == hsh["city"].downcase &&
        state_code.downcase == hsh["state_code"].downcase &&
          country.downcase == hsh["country_code"].downcase
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
end