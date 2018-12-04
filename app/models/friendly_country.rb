class FriendlyCountry
  def self.call(record, **options)
    return "" unless record.respond_to?(:address_details)
    return "" if record.address_details.nil? or record.address_details.strip == ""

    friendly_country = new(record)

    default_options = {
      prefix: true,
      short_code: false,
      source: :address_details,
    }

    merged_options = default_options.merge(options)

    if merged_options[:short_code]
      friendly_country.as_short_code
    elsif merged_options[:prefix]
      friendly_country.with_prefix
    else
      friendly_country.country_name(merged_options)
    end
  end

  attr_accessor :record

  def initialize(record)
    @record = record
  end

  def as_short_code
    result.code
  end
  alias :country_code :as_short_code

  def with_prefix
    if result.code
      "#{result.code} - #{country_name}"
    else
      country_name
    end
  end

  def country_name(**options)
    result(options).name || record.address_details
  end

  private
  def result(**options)
    if options[:source] == :country_code
      Carmen::Country.coded(record.address_details) || Carmen::Country.named(record.address_details)
    else
      Carmen::Country.coded(record.country) || Carmen::Country.named(record.country)
    end
  end
end