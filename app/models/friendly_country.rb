class FriendlyCountry
  def self.call(record, **options)
    return "" unless record.respond_to?(:address_details)
    return "" if record.address_details.nil? or record.address_details.strip == ""

    friendly_country = new(record)

    default_options = {
      prefix: true,
      short_code: false,
      source: :address_details
    }

    merged_options = default_options.merge(**options)

    if merged_options[:short_code]
      friendly_country.as_short_code
    elsif merged_options[:prefix]
      friendly_country.with_prefix
    else
      friendly_country.country_name(**merged_options)
    end
  end

  attr_accessor :record

  def initialize(record)
    @record = record
  end

  def as_short_code
    result.country_code
  end
  alias_method :country_code, :as_short_code

  def with_prefix
    if result.country_code
      "#{result.country_code} - #{country_name}"
    else
      country_name
    end
  end

  def country_name(**options)
    result(**options).country || record.address_details
  end

  private

  def result(**options)
    if options[:source] == :country_code
      country = Carmen::Country.coded(record.address_details)
      Geocoded.new(OpenStruct.new(country: country.name))
    elsif result = Geocoder.search(record.address_details).first
      Geocoded.new(result)
    else
      record
    end
  end
end
