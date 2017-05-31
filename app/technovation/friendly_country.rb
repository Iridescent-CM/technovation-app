module FriendlyCountry
  def self.call(record, options = {})
    return unless record.respond_to?(:country)
    return if record.country.nil? or record.country.strip == ""
    return record.country if Carmen::Country.coded(record.country).blank?

    default_options = {
      prefix: true,
    }

    merged_options = default_options.merge(options)

    if merged_options[:prefix]
      "#{record.country} - #{Carmen::Country.coded(record.country).name}"
    else
      Carmen::Country.coded(record.country).name
    end
  end
end
