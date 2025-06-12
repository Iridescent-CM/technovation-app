FactoryBot.define do
  factory :club do
    sequence(:name) { |n| "FactoryBot Program #{n}" }
    sequence(:summary) { |n| "FactoryBot Summary #{n}" }
    sequence(:headquarters_location) { |n| "FactoryBot Location #{n}" }
    seasons { [Season.current.year] }
    onboarded { true }

    trait :chicago do
      city { "Chicago" }
      state_province { "IL" }
      country { "US" }
    end

    trait :los_angeles do
      city { "Los Angeles" }
      state_province { "CA" }
      country { "US" }
    end

    trait :brazil do
      city { "Salvador" }
      state_province { "Bahia" }
      country { "BR" }
    end
  end
end
