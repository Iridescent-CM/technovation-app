class GeolocationResultsController < ApplicationController
  def index
    lat = params.fetch(:lat)
    lng = params.fetch(:lng)
    query = GeolocationQuery.new(lat: lat, lng: lng)

    city = ""
    state = ""
    country = ""

    candidates = GeolocationCandidates.new(query)

    render json: candidates
  end
end