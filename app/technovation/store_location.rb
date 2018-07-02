module StoreLocation
  def self.call(options)
    location_storage = LocationStorage.for(options)
    location_storage.execute
  end

  class LocationStorage
    def self.for(options)
      if options.fetch(:ip_address) { false }
        IPLocationStorage.new(options.fetch(:ip_address), options.fetch(:context))
      else
        raise ArgumentError,
          "LocationStorage subclass not found for given options - try `ip_address`"
      end
    end

    def execute
      existing_value = context.get_cookie(cookie_name)

      if String(existing_value) == "[0.0, 0.0]"
        status = "EXECUTED"
        context.set_cookie(cookie_name, cookie_value)
      else
        status = !!existing_value ? "SKIPPED" : "EXECUTED"
      end

      Rails.logger.info(
        [
          "[StoreLocation #execute #{status}]",
          log_label,
          log_message,
        ].join(" - ")
      )
    end

    private
    def first_geocoded_result(search_value)
      @first_geocoded_result ||= geocoded_results(search_value).first
    end

    def geocoded_results(search_value)
      @geocoded_results ||= geocoder.search(search_value)
    end

    def log_message
      [
        "[Account##{context.current_account.id}] ",
        "[SOURCE #{source}] ",
        "[COOKIE ",
        String(
          context.get_cookie(cookie_name) ||
            context.set_cookie(cookie_name, cookie_value)
        ),
        "]"
      ].join("")
    end

    def geocoder
      Geocoder
    end
  end

  class IPLocationStorage < LocationStorage
    attr_reader :ip_address, :context, :cookie_name

    def initialize(ip_address, context)
      @ip_address = ip_address
      @context = context
      @cookie_name = CookieNames::IP_GEOLOCATION
    end

    def source
      ip_address
    end

    def cookie_value
      return @cookie_value if defined?(@cookie_value)
      @cookie_value = first_geocoded_result(ip_address).coordinates
    end

    private
    def log_label
      "LAT, LNG from IP"
    end
  end
end