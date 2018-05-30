FactoryBot.define do
  factory :regional_pitch_event,
    aliases: [:event, :rpe],
    class: RegionalPitchEvent do

    ambassador

    name "RPE"
    starts_at { Date.current }
    ends_at { Date.current + 1.day }
    city "City"
    venue_address "123 Street St."
    unofficial false

    seasons { [Season.current.year] }

    division_ids { Division.pluck(:id) }

    trait :brazil do
      association(:ambassador, factory: [:ambassador, :brazil])
    end

    trait :los_angeles do
      association(:ambassador, factory: [:ambassador, :los_angeles])
    end

    trait :chicago do
      association(:ambassador, factory: [:ambassador, :chicago])
    end

    trait :senior do
      division_ids { [Division.senior.id] }
    end

    trait :junior do
      division_ids { [Division.junior.id] }
    end
  end
end
