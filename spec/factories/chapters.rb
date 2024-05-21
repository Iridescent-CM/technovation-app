FactoryBot.define do
  factory :chapter do
    sequence(:name) { |n| "FactoryBot Program #{n}" }
    sequence(:organization_name) { |n| "FactoryBot Organization #{n}" }
    visible_on_map { true }

    association :legal_contact
  end
end
