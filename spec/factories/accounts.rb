FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "account-#{n}@example.com" }
    password { "secret1234" }
    email_confirmed_at { Time.current }

    date_of_birth { Date.today - 31.years }
    first_name { "Factory" }
    last_name { "Account" }

    city { "Chicago" }
    state_province { "IL" }
    country { "US" }

    gender { "Prefer not to say" }

    seasons { [] }

    trait :past do
      seasons { [Season.current.year - (1..99).to_a.sample] }
    end

    trait :returning do
      seasons { [Season.current.year - 1, Season.current.year] }
    end

    trait :mentor do
      mentor_profile
    end

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
      state_province { "BA" }
      country { "BR" }
    end

    after(:create) do |a|
      if a.seasons.empty?
        RegisterToCurrentSeasonJob.perform_now(a)
      end

      a.update_column(:profile_image, "foo/bar/baz.png")
    end
  end
end
