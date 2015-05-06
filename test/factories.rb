# Contained in this file: one factory per class to provide the simplest set of
# attributes necessary to create an instance of that class.

FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "User#{ n }" }
    last_name "Stub"
    home_city "Angel Grove"
    school "Angel Grove High School"
    sequence(:email) { |n| "email#{ n }@example.com" }
    sequence(:parent_email) { |n| "parent#{ n }@example.com" }
    password "testtest"
    birthday { 16.years.ago }
  end
end
