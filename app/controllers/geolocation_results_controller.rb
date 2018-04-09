class GeolocationResultsController < ApplicationController
  def index
    lat = params.fetch(:lat)
    lng = params.fetch(:lng)

    query = GeolocationQuery.new(lat: lat, lng: lng)
    candidates = GeolocationCandidates.new(query)

    render json: candidates.get_reverse_results
  end
end