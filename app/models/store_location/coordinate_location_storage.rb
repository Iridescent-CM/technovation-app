module StoreLocation
  class CoordinateLocationStorage < LocationStorage
    attr_reader :coordinates

    def initialize(coordinates, account, context)
      @coordinates = coordinates
      @account = account
      @context = context
      @cookie_name = CookieNames::IP_GEOLOCATION
    end

    def cookie_value
      {
        "ip_address" => existing_ip,
        "coordinates" => [account.latitude, account.longitude],
        "overwritten_by" => "user"
      }
    end

    private

    def log_label
      "OVERWRITE! LAT, LNG for IP"
    end

    def should_execute?
      true
    end

    def maybe_run_account_updates
      false
    end

    def source
      coordinates
    end
  end
end
