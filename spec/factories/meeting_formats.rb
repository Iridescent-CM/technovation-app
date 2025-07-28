FactoryBot.define do
  factory :meeting_format do
    sequence(:name) { |n| "FactoryBot Meeting Format #{n}" }
  end
end
