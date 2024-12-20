FactoryBot.define do
  factory :club_ambassador_profile, aliases: [
    :club_ambassador,
    :club_ambassador_account
  ] do
    job_title { "Engineer" }

    account { association :account, meets_minimum_age_requirement: true }

    transient do
      city { "Chicago" }
      state_province { "IL" }
      country { "US" }
      sequence(:email) { |n| "factory-club-ambassador-#{n}@example.com" }
      password { nil }
      first_name { "Club Ambassador" }
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
      state_province { "Bahia" }
      country { "BR" }
    end

    trait :geocoded do
      after(:create) do |r, _|
        Geocoding.perform(r.account).with_save
      end
    end

    before(:create) do |r, e|
      {
        city: e.city,
        state_province: e.state_province,
        country: e.country,
        first_name: e.first_name,
        skip_existing_password: true,
        meets_minimum_age_requirement: true
      }.each do |k, v|
        r.account.send(:"#{k}=", v)
      end
    end

    after(:create) do |r, e|
      ProfileCreating.execute(r, FakeController.new)
    end

    trait :has_judge_profile do
      after(:create) do |club_ambassador|
        CreateJudgeProfile.call(club_ambassador.account)
      end
    end

    trait :has_mentor_profile do
      after(:create) do |club_ambassador|
        CreateMentorProfile.call(club_ambassador.account)
      end
    end
  end
end
