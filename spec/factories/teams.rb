FactoryGirl.define do
  factory :team do
    id nil
    name { Faker::Name.name }
    slug { name.parameterize }
    region { build :region }
    division nil
    confirm_acceptance_of_rules { Faker::Boolean.boolean }
    avatar_file_name { Faker::Name.name }
    year Date.today.year
    code { Faker::Internet.url }
    pitch { Faker::Internet.url }
    association :event
  end
end
