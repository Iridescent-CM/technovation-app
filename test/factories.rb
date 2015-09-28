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
    consent_signed_at { 1.minute.ago }

    after(:create) { |u| u.confirm! }
  end

  factory :team do
    sequence(:name) { |n| "Team #{ n }" }
    year { Setting.year }
    region { Region.first }
    category { Category.last }
    code "http://drive.google.com/FAKE_URL_HERE"
    pitch "255 characters leading up to some pitch for this app"
    description "a longer text description for the app going on forever"
    demo "http://www.youtube.com/watch?v=HEXSTRINGHERE"
  end

  factory :rubric do
    identify_problem 1
    address_problem 1
    functional 1
    external_resources 1
    match_features 1
    interface 1
    description 1
    market 1
    competition 1
    revenue 1
    branding 1
    pitch 1
  end

  factory :region do
    region_name 'Test Region'
    division 1
    num_finalists 1
  end
end
