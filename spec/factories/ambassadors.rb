FactoryBot.define do
  factory :chapter_ambassador_profile, aliases: [
    :ambassador,
    :chapter_ambassador,
    :ambassador_account,
    :chapter_ambassador_account
  ] do
    organization_company_name { "FactoryBot" }
    job_title { "Engineer" }
    organization_status { "employee" }
    bio { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet." }
    training_completed_at { Time.now }
    viewed_community_connections { true }

    account { association :account, meets_minimum_age_requirement: true }

    transient do
      city { "Chicago" }
      state_province { "IL" }
      country { "US" }
      sequence(:email) { |n| "factory-chapter-ambassador-#{n}@example.com" }
      password { nil }
      first_name { "Chapter Ambassador" }
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

    trait :assigned_to_chapter do
      after(:create) do |chapter_ambassador|
        chapter_ambassador.account.chapters.destroy_all

        chapter_ambassador.chapterable_assignments.create(
          account: chapter_ambassador.account,
          chapterable: FactoryBot.create(:chapter),
          season: Season.current.year,
          primary: true
        )
      end
    end

    trait :not_assigned_to_chapter do
      after(:create) do |chapter_ambassador|
        chapter_ambassador.account.reload.chapters.destroy_all
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

      r.build_volunteer_agreement(FactoryBot.attributes_for(:volunteer_agreement))
    end

    after(:create) do |r, e|
      chapter = FactoryBot.create(:chapter, primary_contact: r.account)

      r.chapters.destroy_all

      r.chapterable_assignments.create(
        chapterable: chapter,
        account: r.account,
        season: Season.current.year,
        primary: true
      )

      ProfileCreating.execute(r, FakeController.new)
    end

    trait :approved do
      after(:create) do |m|
        m.approved!
        a = m.account
        a.save!
      end
    end

    trait :brazil do
      country { "BR" }
      state_province { "Bahia" }
      city { "Salvador" }
    end

    trait :has_judge_profile do
      after(:create) do |ambassador|
        CreateJudgeProfile.call(ambassador.account)
      end
    end

    trait :has_mentor_profile do
      after(:create) do |ambassador|
        CreateMentorProfile.call(ambassador.account)
      end
    end
  end
end
