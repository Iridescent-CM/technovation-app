FactoryBot.define do
  factory :parental_consent_request do
    student_profile

    delivery_method { :sms }
    external_message_id { "123456789" }
    recipient { "+11231231234" }
    sent_at { Time.now }
    season { Season.current.year }
  end
end
