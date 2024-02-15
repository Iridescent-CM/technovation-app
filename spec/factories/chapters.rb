FactoryBot.define do
  factory :chapter do
    sequence(:name) { |n| "FactoryBot Program #{n}" }
    sequence(:organization_name) { |n| "FactoryBot Organization #{n}" }
  end
end
