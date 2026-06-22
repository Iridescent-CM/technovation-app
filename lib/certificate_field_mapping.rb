# frozen_string_literal: true

module CertificateFieldMapping
  RECIPIENT_NAME_KEYS = %w[fullname recipientname].freeze
  DESCRIPTION_KEYS = %w[fulltext description].freeze
  DIVISION_KEYS = %w[division level].freeze

  DESCRIPTION_PREFIXES = %w[
    judgedescription
    mentordescription
    participantdescription
    chapterambdescription
    coachdescription
    volunteerdescription
    textfield
  ].freeze

  module_function

  def value_key(field_name)
    name = field_name.to_s
    normalized = normalize(name)

    if recipient_name_field?(name)
      :recipient_name
    elsif description_field?(name)
      :full_text
    elsif division_field?(name)
      :division
    elsif normalized == "teamname"
      :team_name
    elsif normalized == "appname"
      :app_name
    elsif normalized == "regionname"
      :region
    else
      name.to_sym
    end
  end

  def recipient_name_field?(field_name)
    normalized = normalize(field_name)

    return true if RECIPIENT_NAME_KEYS.include?(normalized)
    return true if normalized.match?(/\Arecipient\d*\z/)
    return true if normalized.match?(/\Arecipientname\d*\z/)

    field_name == "Recipient Name" ||
      field_name == "Name" ||
      field_name == "recipient_name"
  end

  def description_field?(field_name)
    normalized = normalize(field_name)

    return true if DESCRIPTION_KEYS.include?(normalized)
    return true if DESCRIPTION_PREFIXES.any? { |prefix| normalized.start_with?(prefix) }
    return true if field_name.match?(/\Adescription \d+\z/i)

    field_name == "full_text" ||
      field_name.match?(/Description/i) ||
      field_name.match?(/\AText Field \d+\z/i) ||
      field_name.match?(/\Adescription\z/i) ||
      field_name.match?(/\Adescription \d+\z/i)
  end

  def division_field?(field_name)
    DIVISION_KEYS.include?(normalize(field_name)) ||
      field_name.match?(/\ADIVISION\z/i) ||
      field_name == "LEVEL"
  end

  def normalize(field_name)
    field_name.to_s.downcase.gsub(/[\s_]/, "")
  end
end
