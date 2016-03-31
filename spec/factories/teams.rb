FactoryGirl.define do
  factory :team do
    name { Faker::Name.name }
    region nil

  end
end
