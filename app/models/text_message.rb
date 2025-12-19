class TextMessage < ActiveRecord::Base
  include Seasoned
  enum delivery_method: %i[sms whatsapp]
  enum message_type: %i[parental_consent]

  scope :parental_consent, ->{where(message_type: :parental_consent)}

  belongs_to :account
end
