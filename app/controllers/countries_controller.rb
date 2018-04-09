class CountriesController < ApplicationController
  def index
    if current_account.authenticated?
      render json: CountryStateSelect.countries_collection
    else
      head 401
    end
  end
end