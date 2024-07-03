FactoryBot.define do
  factory :organization_type do
    sequence(:name) { |n| "FactoryBot Organization Type #{n}" }
  end
end
