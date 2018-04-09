class GeolocationCandidates
  include Enumerable

  attr_reader :query, :results

  def initialize(query)
    @query = query
    @results = []
  end

  def get_results
    geocoding = Geocoder.search(query.to_geocodable)

    if geocoding.empty?
      geocoding = Geocoder.search(query.to_geocodable, lookup: :bing)
    end

    set_results(geocoding)
  end

  def get_reverse_results
    geocoding = Geocoder.search(query.to_reverse_geocodable)

    if geocoding.empty?
      geocoding = Geocoder.search(query.to_reverse_geocodable, lookup: :bing)
    end

    set_results(geocoding)
  end

  private
  def set_results(geocoding)
    potential_results = geocoding.map do |g|
      GeolocationResult.new(
        g,
        query.lat || g.latitude,
        query.lng || g.latitude
      )
    end

    potential_results.each do |result|
      next if result.incomplete?

      unless @results.detect { |r| r == result }
        @results.push(result)
      end
    end

    @results
  end

  def each(&block)
    results.each { |r| block.call(r) }
  end
end