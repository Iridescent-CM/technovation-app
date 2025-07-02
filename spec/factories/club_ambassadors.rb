FactoryBot.define do
  factory :club_ambassador_profile, aliases: [
    :club_ambassador,
    :club_ambassador_account
  ] do
    job_title { "Engineer" }
    training_completed_at { Time.now }
    viewed_community_connections { true }
    onboarded { true }

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

    trait :not_assigned_to_club do
      after(:create) do |club_ambassador|
        club_ambassador.account.chapterable_assignments.destroy_all
      end
    end

    trait :training_not_completed do
      training_completed_at { nil }
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

      unless r.background_check.present?
        r.account.build_background_check(FactoryBot.attributes_for(:background_check))
      end

      unless r.consent_signed?
        r.account.build_consent_waiver(FactoryBot.attributes_for(:consent_waiver))
      end
    end

    after(:create) do |r, e|
      club = FactoryBot.create(:club, primary_contact: r.account)

      r.clubs.destroy_all

      r.chapterable_assignments.create(
        chapterable: club,
        account: r.account,
        season: Season.current.year,
        primary: true
      )

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
