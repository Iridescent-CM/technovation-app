FactoryGirl.define do
  factory :rpe, class: RegionalPitchEvent do
    regional_ambassador_profile

    name "RPE"
    starts_at { Date.today }
    ends_at { Date.today + 1.day }
    city "City"
    venue_address "123 Street St."
    unofficial false

    transient do
      divisions %i{senior junior}
    end

    before(:create) do |r, e|
      e.divisions.each do |d|
        r.divisions << Division.public_send(d)
      end
    end
  end
end
