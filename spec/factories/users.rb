FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    home_city { Faker::Address.city }
    home_country { Faker::Lorem.characters(2) }
    school { Faker::Name.first_name }
    parent_email { Faker::Internet.email }
    email { Faker::Internet.email }
    judging { false }
    birthday { Faker::Date.between(2.days.ago, Date.today) }
    password { Faker::Internet.password }
    role 2
    is_registered true
    expertise 31
    consent_signed_at { DateTime.now }

    trait :student do
      role 0
    end

    trait :mentor do
      role 1
    end

    trait :coach do
      role 2
    end

    trait :judge do
      role 3
    end

    trait :with_fake_cheker do
      bg_check_id 'fake'
      bg_check_submitted DateTime.now
    end

    factory :mentor, traits: [:mentor, :with_fake_cheker]
  end
end
