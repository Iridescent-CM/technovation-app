FactoryGirl.define do
  factory :team do
    id nil
    name { Faker::Name.name }
    slug { name.parameterize }
    region { build :region }
    division { Faker::Number.between(0, 2) }
    confirm_acceptance_of_rules { Faker::Boolean.boolean }
    avatar_file_name { Faker::Name.name }
    year nil

    association :event
  end
end
