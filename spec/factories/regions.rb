FactoryGirl.define do
  factory :region do
    id nil
    region_name { Faker::Name.name }
    division { Faker::Number.between(0, 2) }
  end
end
