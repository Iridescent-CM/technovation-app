FactoryBot.define do
  factory :meeting_facilitator do
    sequence(:name) { |n| "FactoryBot Meeting Facilitator #{n}" }
  end
end
