FactoryBot.define do
  factory :meeting_time do
    sequence(:time) { |n| "FactoryBot Metting Time #{n}" }
  end
end
