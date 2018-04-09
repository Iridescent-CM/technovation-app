class GeolocationQuery
  attr_reader :lat, :lng, :city, :state, :country

  def initialize(lat: nil, lng: nil, city: nil, state: nil, country: nil)
    @lat = lat
    @lng = lng
    @city = city
    @state = state
    @country = country
  end

  def to_reverse_geocodable
    [lat, lng].join(",")
  end

  def to_geocodable
    [city, state, country].join(",")
  end
end