module StoreLocation
  def self.call(options)
    location_storage = LocationStorage.for(options)
    location_storage.execute
  end

  class LocationStorage
    def self.for(options)
      if options.fetch(:ip_address) { false }
        IPLocationStorage.new(
          options.fetch(:ip_address),
          options.fetch(:account),
          options.fetch(:context),
        )
      else
        raise ArgumentError,
          "LocationStorage subclass not found for given options - try `ip_address`"
      end
    end

    attr_reader  :account, :context, :cookie_name

    def execute
      if should_execute?
        status = "EXECUTED"
        context.set_cookie(cookie_name, cookie_value)
      else
        status = "SKIPPED"
      end

      maybe_run_account_updates

      Rails.logger.info(
        [
          "[StoreLocation #execute #{status}]",
          log_label,
          log_message(get_or_set_value),
        ].join(" - ")
      )
    end

    def get_or_set_value
      context.get_cookie(cookie_name) ||
        context.set_cookie(cookie_name, cookie_value) &&
          context.get_cookie(cookie_name)
    end

    private
    def first_geocoded_result(search_value)
      @first_geocoded_result ||= geocoded_results(search_value).first ||
        StoreLocation::NullGeocodedResult.new
    end

    def geocoded_results(search_value)
      @geocoded_results ||= geocoder.search(search_value)
    end

    def log_message(value)
      [
        "[Account##{context.current_account.id}]",
        "[SOURCE #{source}]",
        "[COOKIE #{String(value)}]",
      ].join(" ")
    end

    def geocoder
      Geocoder
    end
  end

  class IPLocationStorage < LocationStorage
    attr_reader :ip_address

    def initialize(ip_address, account, context)
      @ip_address = ip_address
      @account = account
      @context = context
      @cookie_name = CookieNames::IP_GEOLOCATION
    end

    def maybe_run_account_updates
      if coordinates_valid? &&
          account.authenticated? &&
            (!account.latitude || !account.city)
        account.latitude  = latitude
        account.longitude = longitude
        Geocoding.perform(account).with_save
      else
        false
      end
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
      @cookie_value ||= if account.authenticated? && account.latitude
        {
          'ip_address'  => ip_address,
          'coordinates' => [account.latitude, account.longitude],
        }
      else
        {
          'ip_address'  => ip_address,
          'coordinates' => first_geocoded_result(ip_address).coordinates,
        }
      end
    end

    private
    def log_label
      "LAT, LNG from IP"
    end

    def existing_value
      context.get_cookie(cookie_name)
    end

    def existing_coordinates
      existing_value && existing_value['coordinates']
    end

    def existing_ip
      existing_value && existing_value['ip_address']
    end

    def should_execute?
      !existing_value ||
        !existing_coordinates ||
          !coordinates_valid? ||
            String(ip_address) != String(existing_ip)
    end

    def coordinates_valid?
      existing_coordinates && String(existing_coordinates) != "[0.0, 0.0]"
    end
  end

  class NullGeocodedResult
    def coordinates
      [0.0, 0.0]
    end
  end
end