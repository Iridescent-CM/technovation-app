module Public
  class CountriesController < ApplicationController
    def show
      name = params.fetch(:name, nil)
      code = params.fetch(:code, nil)

      if name
        countries_or_regions = Carmen::Country.named(name).subregions.map do |subregion|
          subregion.name
        end
      elsif code
        countries_or_regions = Carmen::Country.coded(code).subregions.map do |subregion|
          subregion.name
        end
      else
        countries_or_regions = Carmen::Country.all.map do |country|
          country.name
        end
      end

      render :json => countries_or_regions.sort
    end
  end
end
