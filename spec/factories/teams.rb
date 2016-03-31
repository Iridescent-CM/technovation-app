FactoryGirl.define do
  factory :team do
    name { Faker::Name.name }
    region { build :region }
    division { Faker::Number.between(0,2) }
  end
end
