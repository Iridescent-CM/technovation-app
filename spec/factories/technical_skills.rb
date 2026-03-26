FactoryBot.define do
  factory :technical_skill do
    sequence(:name) { |n| "Factory Technical Skill #{n}" }
    sequence(:order) { |n| n }
  end
end
