module StoreLocation
  class IPLocationStorage < LocationStorage
    attr_reader :ip_address

    def initialize(ip_address, account, context)
      @ip_address = ip_address
      @account = account
      @context = context
      @cookie_name = CookieNames::IP_GEOLOCATION
    end

    def maybe_run_account_updates
      if !cookie_overwritten? &&
          coordinates_valid? &&
          account.authenticated? &&
          coordinates_different?(account.coordinates)
        account.latitude = latitude
        account.longitude = longitude
        Geocoding.perform(account).with_save
      else
        false
      end
    end

    def coordinates_different?(coordinates)
      existing_coordinates[0] != coordinates[0] ||
        existing_coordinates[1] != coordinates[1]
    end

    def latitude
      existing_coordinates.first
    end

    def longitude
      existing_coordinates.last
    end

    def source
      ip_address
    end

    def cookie_value
      if account.authenticated? && account.valid_coordinates?
        {
          "ip_address" => ip_address,
          "coordinates" => [account.latitude, account.longitude],
          "overwritten_by" => nil,
          "written_by" => "platform"
        }
      else
        {
          "ip_address" => ip_address,
          "coordinates" => first_geocoded_result.coordinates,
          "overwritten_by" => nil,
          "written_by" => "platform"
        }
      end
    end

    private

    def log_label
      "LAT, LNG from IP"
    end

    def should_execute?
      !cookie_overwritten? &&
        (!existing_value ||
          !existing_coordinates ||
            !coordinates_valid? ||
              String(ip_address) != String(existing_ip))
    end

    def first_geocoded_result
      @geocoded_results ||= geocoder.search(source)

      @first_geocoded_result ||= @geocoded_results.first ||
        ::NullGeocodedResult.new
    end
  end
end
