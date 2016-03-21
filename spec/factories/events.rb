FactoryGirl.define do
  factory :event do
    is_virtual nil

    trait :virtual_event do
      is_virtual true
    end

    trait :non_virtual_event do
      is_virtual false
    end
  end

end
