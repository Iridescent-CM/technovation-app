FactoryBot.define do
  factory :join_request do
    association(:requestor, factory: :mentor)
    association(:team)

    trait :pending do
      accepted_at nil
      declined_at nil
    end

    trait :accepted do
      accepted_at { Time.current }
      declined_at nil
    end

    trait :declined do
      declined_at { Time.current }
      accepted_at nil
    end
  end
end
