module FriendlyCountry
  def self.call(record, options = {})
    return unless record.respond_to?(:country)
    return if record.country.nil? or record.country.strip == ""
    return record.country if Country[record.country].blank?

    default_options = {
      prefix: true,
    }

    merged_options = default_options.merge(options)

    if merged_options[:prefix]
      "#{record.country} - #{Country[record.country].name}"
    else
      Country[record.country].name
    end
  end
end
