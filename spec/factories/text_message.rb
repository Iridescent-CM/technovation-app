FactoryBot.define do
  factory :text_message do
    account

    delivery_method { :sms }
    message_type { :parental_consent }
    external_message_id { "123456789" }
    recipient { "+11231231234" }
    sent_at { Time.now }
    season { Season.current.year }
  end
end
