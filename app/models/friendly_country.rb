module FriendlyCountry
  def self.call(record, options = {})
    return "" unless record.respond_to?(:country)
    return "" if record.country.nil? or record.country.strip == ""

    country = Carmen::Country.coded(record.country) ||
                Carmen::Country.named(record.country)

    return record.country if country.blank?

    default_options = {
      prefix: true,
      short_code: false,
    }

    merged_options = default_options.merge(options)

    if merged_options[:short_code]
      country.code
    elsif merged_options[:prefix]
      "#{country.code} - #{country.name}"
    else
      country.name
    end
  end
end
