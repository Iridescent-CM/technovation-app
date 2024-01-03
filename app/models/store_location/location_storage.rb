module StoreLocation
  class LocationStorage
    def self.for(options)
      if options.fetch(:ip_address) { false }
        StoreLocation::IPLocationStorage.new(
          options.fetch(:ip_address),
          options.fetch(:account) { ::NullAccount.new },
          options.fetch(:context)
        )
      elsif options.fetch(:coordinates) { false }
        StoreLocation::CoordinateLocationStorage.new(
          options.fetch(:coordinates),
          options.fetch(:account),
          options.fetch(:context)
        )
      else
        raise ArgumentError,
          "LocationStorage subclass not found for given options - try `ip_address`"
      end
    end

    attr_reader :account, :context, :cookie_name

    def execute
      if should_execute?
        status = "EXECUTED"
        context.set_cookie(cookie_name, cookie_value)
        maybe_run_account_updates
      else
        status = "SKIPPED"
      end

      Rails.logger.info(
        [
          "[StoreLocation #execute #{status}]",
          log_label,
          log_message(get_or_set_value)
        ].join(" - ")
      )
    end

    def get_or_set_value
      context.get_cookie(cookie_name) ||
        context.set_cookie(cookie_name, cookie_value) &&
          context.get_cookie(cookie_name)
    end

    private

    def log_message(value)
      [
        "[Account##{account.id}]",
        "[SOURCE #{source}]",
        "[COOKIE #{String(value)}]"
      ].join(" ")
    end

    def geocoder
      Geocoder
    end

    def existing_value
      context.get_cookie(cookie_name)
    end

    def existing_coordinates
      existing_value && existing_value["coordinates"]
    end

    def existing_ip
      existing_value && existing_value["ip_address"]
    end

    def coordinates_valid?
      existing_coordinates &&
        String(existing_coordinates) != "[0.0, 0.0]" &&
        String(existing_coordinates) != "[nil, nil]"
    end

    def cookie_overwritten?
      !!cookie_value["overwritten_by"]
    end
  end
end
