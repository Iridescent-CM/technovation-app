module FriendlyCountry
  def self.call(record)
    return unless record.respond_to?(:country)
    return if record.country.blank?
    return record.country if Country[record.country].blank?

    "#{record.country} - #{Country[record.country].name}"
  end
end
