FactoryBot.define do
  factory :judge_type do
    sequence(:name) { |n| "Factory Judge Type #{n}" }
    sequence(:order) { |n| n }
  end
end
