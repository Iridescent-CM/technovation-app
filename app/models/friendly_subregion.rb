module FriendlySubregion
  def self.call(record, options = {})
    return "" unless record.respond_to?(:country) and
      record.respond_to?(:state_province)

    return "" if (record.country.nil? or record.country.strip == "") or
      (record.state_province.nil? or record.state_province.strip == "")

    country = Carmen::Country.coded(record.country) ||
      Carmen::Country.named(record.country)

    return record.state_province.strip if country.blank?
    return record.state_province.strip if country.subregions.empty?

    subregion = country.subregions.coded(record.state_province) ||
      country.subregions.named(record.state_province)

    return record.state_province.strip if subregion.blank?

    default_options = {
      prefix: true,
      short_code: false
    }

    merged_options = default_options.merge(options)

    if merged_options[:short_code]
      subregion.code
    elsif merged_options[:prefix]
      "#{subregion.code} - #{subregion.name}"
    else
      subregion.name
    end
  end
end
