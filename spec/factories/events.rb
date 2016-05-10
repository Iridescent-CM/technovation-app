FactoryGirl.define do
  factory :event do
    is_virtual false
    when_to_occur nil

    name { Faker::Name.first_name }

    trait :virtual_event do
      is_virtual true
    end

    trait :non_virtual_event do
      is_virtual false
    end
  end
end
