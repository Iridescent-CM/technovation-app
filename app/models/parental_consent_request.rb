class ParentalConsentRequest < ActiveRecord::Base
  include Seasoned
  enum delivery_method: %i[sms whatsapp]

  belongs_to :student_profile
end
