class TextMessage < ActiveRecord::Base
  enum delivery_method: %i[sms whatsapp]
  enum message_type: %i[parental_consent signed_parental_consent signed_media_consent]

  enum status: %i[
    queued
    sending
    sent
    failed
    delivered
    undelivered
    receiving
    received
    accepted
    read
  ]

  scope :current, -> {
    where(season: Season.current.year)
  }

  scope :parental_consent, ->{where(message_type: :parental_consent)}

  belongs_to :account
end
