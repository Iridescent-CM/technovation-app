class AccountLocationsController < ApplicationController
  before_action -> () {
    if !current_account.authenticated?
      head 401
    end
  }

  def update
    query = GeolocationQuery.new(
      city: location_params[:city],
      state: location_params[:state_province],
      country: location_params[:country]
    )

    candidates = GeolocationCandidates.new(query)
    results = candidates.get_results

    if results.count > 1
      render json: { candidates: results }
    else
      if current_account.update(
        city: results[0].city,
        state_province: results[0].state,
        country: results[0].country,
        latitude: results[0].lat,
        longitude: results[0].lng,
      )
        render json: {}, status: 200
      else
        render json: { errors: current_account.errors }, status: 403
      end
    end
  end

  private
  def location_params
    params.require(:account).permit(:city, :state_province, :country)
  end
end
