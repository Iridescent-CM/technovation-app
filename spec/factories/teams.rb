FactoryGirl.define do
  factory :team do
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

    trait :eligible do
      code 'ok'
      plan { File.open('./spec/support/files/plan_example.pdf') }
      pitch 'ok'
      confirm_acceptance_of_rules true
      confirm_region true
    end
  end
end
