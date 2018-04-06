class GeolocationResultsController < ApplicationController
  def index
    lat = params.fetch(:lat)
    lng = params.fetch(:lng)
    query = Query.new(lat, lng)

    city = ""
    state = ""
    country = ""

    candidates = Candidates.new(query)

    render json: candidates
  end
end

class Query
  attr_reader :lat, :lng

  def initialize(lat, lng)
    @lat = lat
    @lng = lng
  end

  def to_geocodable
    [lat, lng].join(",")
  end
end

class Candidates
  include Enumerable

  attr_reader :query, :results

  def initialize(query)
    @query = query
    @results = []

    geocoding = Geocoder.search(query.to_geocodable)
    if geocoding.empty?
      geocoding = Geocoder.search(query.to_geocodable, lookup: :bing)
    end

    potential_results = geocoding.map { |g| Result.new(g, query.lat, query.lng) }

    potential_results.each do |result|
      next if result.incomplete?

      unless @results.detect { |r| r == result }
        @results.push(result)
      end
    end
  end

  def each(&block)
    results.each { |r| block.call(r) }
  end

  class Result
    attr_reader :city, :state, :country, :lat, :lng

    def initialize(geocoding_result, lat, lng)
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
  end

  private
  def inside_palestine_bbox?
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
