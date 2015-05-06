# Contained in this file: one factory per class to provide the simplest set of
# attributes necessary to create an instance of that class.

FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "User#{ n }" }
    last_name "Stub"
    home_city "Angel Grove"
    school "Angel Grove High School"
    email { "#{first_name}.#{last_name}@example.com".downcase }
    parent_email { "#{first_name}.#{last_name}.parent@example.com".downcase }
    password "testtest"
    birthday { 16.years.ago }
    home_country 'US'

    after(:create) { |u| u.confirm! }
  end
end
