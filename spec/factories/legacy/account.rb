FactoryGirl.define do
  factory :legacy_account, class: Account do
    sequence(:email) { |n| "legacy-factory-#{n}@example.com" }
    password "secret1234"
    date_of_birth 50.years.ago
    first_name "Legacy"
    last_name "Account"
  end
end
