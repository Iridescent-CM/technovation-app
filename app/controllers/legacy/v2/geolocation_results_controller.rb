module Legacy
  module V2
    class GeolocationResultsController < ApplicationController
      def index
        lat = params.fetch(:lat)
        lng = params.fetch(:lng)
        query = [lat, lng].join(',')
        city = ""
        state = ""
        country = ""

        if geocoded = Geocoder.search(query).first ||
                        Geocoder.search(query, lookup: :bing).first
          city = geocoded.city
          state = geocoded.state_code
          country = geocoded.country_code

          if geocoded.country.blank? and inside_palestine_bbox?(lat, lng)
            country = "PS"
          end

          if city.blank?
            city = geocoded.data.fetch("address") { {} }["adminDistrict2"]
          end
        end

        render json: { city: city, state: state, country: country }
      end

      private
      def inside_palestine_bbox?(lat, lng)
        lat = Float(lat)
        lng = Float(lng)

        bbox = {
          lng_west: 34.2675,
          lat_south: 29.4534,
          lng_east: 35.895,
          lat_north: 33.3356,
        }

        lat > bbox[:lat_south] and
          lat < bbox[:lat_north] and
            lng < bbox[:lng_east] and
              lng > bbox[:lng_west]
      end
    end
  end
end
