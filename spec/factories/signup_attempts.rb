FactoryBot.define do
  factory :signup_attempt do
    sequence(:email) { |n| "signup-attempt-#{n}@example.com" }
    password "secret1234"
    status SignupAttempt.statuses[:active]

    trait :chicago do
      city "Chicago"
      state_code "IL"
      country_code "US"

      after(:create) do |attempt|
        Geocoding.perform(attempt).with_save
      end
    end
  end
end
