module Public
  class CountriesController < ApplicationController
    def show
      name = params.fetch(:name, nil)
      code = params.fetch(:code, nil)

      if name
        countries = Carmen::Country.named(name).to_hash
      elsif code
        countries = Carmen::Country.coded(code).to_hash
      else
        countries = Carmen::Country.all
      end

      render :json => countries
    end
  end
end
