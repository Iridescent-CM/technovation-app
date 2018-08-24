class FriendlyCountry
  def self.call(record, options = {})
    return "" unless record.respond_to?(:country)
    return "" if record.country.nil? or record.country.strip == ""

    friendly_country = new(record)

    default_options = {
      prefix: true,
      short_code: false,
    }

    merged_options = default_options.merge(options)

    if merged_options[:short_code]
      friendly_country.as_short_code
    elsif merged_options[:prefix]
      friendly_country.with_prefix
    else
      friendly_country.country_name
    end
  end

  attr_accessor :record

  def initialize(record)
    @record = record
  end

  def as_short_code
    result.country_code
  end

  def with_prefix
    "#{result.country_code} - #{result.country}"
  end

  def country_name
    result.country
  end

  private
  def result
    if result = Geocoder.search(record.address_details).first
      Geocoded.new(result)
    else
      record
    end
  end
end