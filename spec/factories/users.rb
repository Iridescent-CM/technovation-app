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
  end
end
