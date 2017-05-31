module FriendlySubregion
  def self.call(record, options = {})
    return unless record.respond_to?(:country) and record.respond_to?(:state_province)

    return if (record.country.nil? or record.country.strip == "") or
      (record.state_province.nil? or record.state_province.strip == "")

    return record.state_province if Carmen::Country.coded(record.country).blank?

    country = Carmen::Country.coded(record.country)

    return record.state_province if country.subregions.coded(record.state_province).blank?

    default_options = {
      prefix: true,
    }

    merged_options = default_options.merge(options)

    if merged_options[:prefix]
      "#{record.state_province} - #{country.subregions.coded(record.state_province).name}"
    else
      country.subregions.coded(record.state_province).name
    end
  end
end
