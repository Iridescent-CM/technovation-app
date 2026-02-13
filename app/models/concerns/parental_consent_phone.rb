module ParentalConsentPhone
  extend ActiveSupport::Concern

  included do
    before_validation :format_parent_guardian_phone_number,
      if: -> { parent_guardian_phone_number.present? && parent_guardian_phone_country_code.present? }

    validate :valid_parent_guardian_phone_number,
      if: -> { parent_guardian_phone_number.present? || parent_guardian_phone_country_code.present? }

    before_save :set_parent_guardian_text_message_opted_in_at,
      if: -> { parent_guardian_phone_number.present? && parent_guardian_phone_number_changed? }

    attr_accessor :parent_guardian_phone_country_code
  end

  def in_parental_consent_text_message_country?
    country_codes = ENV.fetch("PARENTAL_CONSENT_TEXT_MESSAGE_COUNTRY_CODES", "").split(",")
    country_codes.include?(account.country_code)
  end

  def can_send_parental_consent_text_message?
    in_parental_consent_text_message_country? &&
      parent_guardian_phone_number.present? &&
      parental_consent_text_messages_remaining > 0
  end

  def parental_consent_text_message_limit_reached?
    parent_guardian_phone_number.present? &&
      parental_consent_text_messages_remaining == 0
  end

  def parental_consent_text_messages_remaining
    ENV.fetch("MAXIMUM_NUMBER_OF_PARENTAL_CONSENT_TEXT_MESSAGES").to_i - account.text_messages.current.parental_consent.whatsapp.count
  end

  def parent_guardian_local_phone_number
    Phonelib.parse(parent_guardian_phone_number).national
  end

  def parent_guardian_friendly_phone_number
    Phonelib.parse(parent_guardian_phone_number).full_international
  end

  private

  def set_parent_guardian_text_message_opted_in_at
    self.parent_guardian_text_message_opted_in_at = Time.current
  end

  def format_parent_guardian_phone_number
    formatted_phone_number = Phonelib.parse("#{parent_guardian_phone_country_code}#{parent_guardian_phone_number}")
    return unless formatted_phone_number.valid?

    self.parent_guardian_phone_number = formatted_phone_number.e164
  end

  def valid_parent_guardian_phone_number
    if parent_guardian_phone_country_code.blank?
      errors.add(:parent_guardian_phone_country_code, "must be selected")
    end

    parsed_phone_number = Phonelib.parse(parent_guardian_phone_number)
    unless parsed_phone_number.valid?
      errors.add(:parent_guardian_phone_number, "is not a valid phone number")
    end
  end
end
