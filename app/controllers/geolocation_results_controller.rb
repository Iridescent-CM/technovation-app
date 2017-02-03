class GeolocationResultsController < ApplicationController
  def index
    lat = params.fetch(:lat)
    lng = params.fetch(:lng)
    query = [lat, lng].join(',')
    geo_str = ""
    country = ""

    geocoded = Geocoder.search(query).first ||
      Geocoder.search(query, lookup: :bing).first

    if !!geocoded
      geo_str = [geocoded.city, geocoded.state, geocoded.country].compact.join(', ')
    end

    if !!geocoded and geocoded.country.blank? and inside_palestine_bbox?(lat, lng)
      country = "PS"
    end

    render json: { geocoded: geo_str, country: country }
  end

  private
  def inside_palestine_bbox?(lat, lng)
    lat = Float(lat)
    lng = Float(lng)

    bbox = {
      lng_west: 34.8747,
      lat_south: 31.3443,
      lng_east: 35.5724,
      lat_north: 32.5584,
    }

    lat > bbox[:lat_south] and
      lat < bbox[:lat_north] and
        lng < bbox[:lng_east] and
          lng > bbox[:lng_west]
  end
end
