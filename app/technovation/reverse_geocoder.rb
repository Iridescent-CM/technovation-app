module ReverseGeocoder
  def update_geocoding_from_results(results)
    if geo = results.first
      self.city = geo.city
      self.state_province = geo.state_code
      country = Country.find_country_by_name(geo.country_code) ||
                  Country.find_country_by_alpha3(geo.country_code) ||
                    Country.find_country_by_alpha2(geo.country_code)
      self.country = country.alpha2
    end
  end
end
