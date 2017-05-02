FactoryGirl.define do
  factory :signup_attempt do
    sequence(:email) { |n| "signup-attempt-#{n}@example.com" }
    password "secret1234"
    status SignupAttempt.statuses[:active]
  end
end
