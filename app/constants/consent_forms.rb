module ConsentForms
  PAPER_CONSENT_UPLOAD_STATUSES = {
    pending: 0,
    approved: 1,
    rejected: 2
  }

  PARENT_GUARDIAN_NAME_FOR_A_PAPER_CONSENT = "ON FILE"
  PARENT_GUARDIAN_EMAIL_ADDRESS_FOR_A_PAPER_CONSENT = "ON FILE"
  ELECTRONIC_SIGNATURE_FOR_A_PAPER_CONSENT = "ON FILE"

  FIRST_SEASON_FOR_UPLOADABLE_CONSENT_FORMS = 2024

  def self.parental_consent_phone_country_code_options
    options = ENV.fetch("PARENTAL_CONSENT_TEXT_MESSAGE_COUNTRY_CODES", "").split(",")
    options.map { |option|
      country = Country.find_country_by_alpha2(option)
      ["#{country.name} (+#{country.country_code})", "+#{country.country_code}"]
    }.sort
  end
end
