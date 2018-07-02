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
  end

  class IPLocationStorage < LocationStorage
    attr_reader :ip_address, :context

    def initialize(ip_address, context)
      @ip_address = ip_address
      @context = context
    end

    def execute
      context.get_cookie(CookieNames::IP_GEOLOCATION) ||
        context.set_cookie(CookieNames::IP_GEOLOCATION, ip_address)
    end
  end
end