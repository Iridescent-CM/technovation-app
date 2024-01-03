FactoryBot.define do
  factory :certificate, aliases: [:cert] do
    account
    team

    season { Season.current.year }

    trait :past do
      season { Season.current.year - (1..10).to_a.sample }
    end
  end
end
