FactoryBot.define do
  factory :student_profile, aliases: [:student, :student_account] do
    account

    school_name { "FactoryBot High" }

    transient do
      first_name "Student"
      city "Chicago"
      state_province "IL"
      country "US"
      date_of_birth Date.today - 14.years
      sequence(:email) { |n| "factory-student-#{n}@example.com" }
      password nil
      not_onboarded false
    end

    trait :chicago do
      city "Chicago"
      state_province "IL"
      country "US"
    end

    trait :los_angeles do
      city "Los Angeles"
      state_province "CA"
      country "US"
    end

    trait :brazil do
      city "Salvador"
      state_province "Bahia"
      country "BR"
    end

    trait :najran do
      city "Najran"
      state_province "Najran Province"
      country "Saudi Arabia"
    end

    trait :dhurma do
      city "Dhurma"
      state_province "Riyadh Province"
      country "Saudi Arabia"
    end

    trait :geocoded do
      before(:create) do |s, _|
        Geocoding.perform(s.account)
      end
    end

    before(:create) do |s, e|
      if e.not_onboarded
        s.build_parental_consent
      else
        s.build_parental_consent(
          FactoryBot.attributes_for(:parental_consent)
            .merge(status: :signed)
        )
      end

      attrs = FactoryBot.attributes_for(:account)

      attrs.merge(
        skip_existing_password: true,
        first_name: e.first_name,
        city: e.city,
        state_province: e.state_province,
        country: e.country,
        date_of_birth: e.date_of_birth,
        email: e.email || attrs[:email],
        password: e.password || attrs[:password],
      ).each do |k, v|
        s.account.send("#{k}=", v)
      end
    end

    after(:create) do |s, e|
      ProfileCreating.execute(s, FakeController.new)
    end

    trait :senior do |s|
      date_of_birth Date.today - 15.years
    end

    trait :junior do |s|
      date_of_birth Date.today - 14.years
    end

    trait :on_team do
      after(:create) do |s|
        team = FactoryBot.create(:team, members_count: 0)
        TeamCreating.execute(team, s, FakeController.new)
      end
    end

    trait :full_profile do
      geocoded
      parent_guardian_email "example@example.com"
      parent_guardian_name "Parenty McGee"
      school_name "My school"
    end

    trait :onboarding do
      not_onboarded true
    end

    factory :onboarded_student, traits: [:full_profile]
    factory :onboarding_student, traits: [:onboarding]
  end
end
