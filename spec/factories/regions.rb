FactoryGirl.define do
  factory :region do
    region_name { Faker::Name.name }
  end
end
