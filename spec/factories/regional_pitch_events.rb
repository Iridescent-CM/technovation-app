FactoryBot.define do
  factory :regional_pitch_event,
    aliases: [:event, :rpe],
    class: RegionalPitchEvent do

    regional_ambassador_profile

    name "RPE"
    starts_at { Date.current }
    ends_at { Date.current + 1.day }
    city "City"
    venue_address "123 Street St."
    unofficial false
    division_ids { Division.pluck(:id) }

    transient do
      divisions %i{senior junior}
    end

    trait :senior do
      divisions %i{senior}
    end

    trait :junior do
      divisions %i{junior}
    end

    before(:create) do |r, e|
      e.divisions.each do |d|
        r.divisions << Division.public_send(d)
      end
    end
  end
end
