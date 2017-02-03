class GeolocationResultsController < ApplicationController
  def index
    query = "#{params.fetch(:lat)},#{params.fetch(:lng)}"

    if geocoded = Geocoder.search(query).first
      geo_str = [geocoded.city, geocoded.state, geocoded.country].join(', ')
      render json: { geocoded: geo_str }
    else
      head 404
    end
  end
end
