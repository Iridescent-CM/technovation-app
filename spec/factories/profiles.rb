FactoryBot.define do
  factory :admin_profile, aliases: [:admin] do
    account
  end

  factory :student_profile, aliases: [:student, :student_account] do
    account

    school_name { "FactoryBot High" }

    transient do
      first_name "Student"
      city "Chicago"
      state_province "IL"
      country "US"
      date_of_birth Date.today - 14.years
      email nil
      password nil
      not_onboarded false
    end

    trait :geocoded do
      after(:create) do |s, _|
        Geocoding.perform(s.account).with_save
      end
    end

    before(:create) do |s, e|
      if e.not_onboarded
        s.build_parental_consent
      else
        s.build_parental_consent(
          FactoryBot.attributes_for(:parental_consent).merge(status: :signed)
        )
      end

      attrs = FactoryBot.attributes_for(:account)

      s.build_account(attrs.merge(
        first_name: e.first_name,
        city: e.city,
        state_province: e.state_province,
        country: e.country || attrs[:country],
        date_of_birth: e.date_of_birth,
        email: e.email || attrs[:email],
        password: e.password || attrs[:password],
      ))
    end

    after(:create) do |s, e|
      ProfileCreating.execute(s, FakeController.new)
    end

    trait :senior do |s|
      date_of_birth Date.today - 15.years
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

  factory :mentor_profile, aliases: [:mentor, :mentor_account] do
    school_company_name { "FactoryBot" }
    job_title { "Engineer" }
    bio "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet."

    transient do
      first_name "Mentor"
      last_name nil
      city "Chicago"
      state_province "IL"
      country "US"
      email nil
      password nil
      date_of_birth nil
      not_onboarded false
    end

    trait :geocoded do
      after(:create) do |m, _|
        Geocoding.perform(m.account).with_save
      end
    end

    before(:create) do |m, e|
      attrs = FactoryBot.attributes_for(:account)

      m.build_account(attrs.merge(
        date_of_birth: e.date_of_birth || attrs[:date_of_birth],
        city: e.city || attrs[:city] || "Chicago",
        state_province: e.state_province || attrs[:state_province] || "IL",
        country: e.country || attrs[:country],
        first_name: e.first_name,
        last_name: e.last_name || attrs[:last_name],
        email: e.email || attrs[:email],
        password: e.password || attrs[:password],
      ))

      if m.requires_background_check? and not e.not_onboarded # TODO: not not_onboarded :/
        m.account.build_background_check(FactoryBot.attributes_for(:background_check))
      end

      unless m.consent_signed? or e.not_onboarded
        m.account.build_consent_waiver(FactoryBot.attributes_for(:consent_waiver))
      end
    end

    after(:create) do |m, e|
      ProfileCreating.execute(m, FakeController.new)
    end

    trait :with_expertises do
      after(:create) do |m|
        2.times do
          FactoryBot.create(:expertise, mentor_profile_ids: m.id)
        end
      end
    end

    trait :on_team do
      after(:create) do |m|
        team = FactoryBot.create(:team)
        FactoryBot.create(
          :team_membership,
          member: m,
          team: team
        )
      end
    end

    factory :onboarded_mentor
  end

  factory :regional_ambassador_profile, aliases: [
    :ambassador,
    :regional_ambassador,
    :ambassador_account,
    :regional_ambassador_account
  ] do
    organization_company_name { "FactoryBot" }
    job_title { "Engineer" }
    ambassador_since_year { Time.current.year }
    bio "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet."

    account

    transient do
      city "Chicago"
      state_province "IL"
      country "US"
      email nil
      password nil
      first_name "RA"
    end

    trait :geocoded do
      after(:create) do |r, _|
        Geocoding.perform(r.account).with_save
      end
    end

    before(:create) do |r, e|
      attrs = FactoryBot.attributes_for(:account)

      r.build_account(attrs.merge(
        city: e.city,
        state_province: e.state_province,
        country: e.country || attrs[:country],
        email: e.email || attrs[:email],
        password: e.password || attrs[:password],
        first_name: e.first_name,
      ))

      unless r.background_check.present?
        r.account.build_background_check(FactoryBot.attributes_for(:background_check))
      end

      unless r.consent_signed?
        r.account.build_consent_waiver(FactoryBot.attributes_for(:consent_waiver))
      end
    end

    after(:create) do |r, e|
      ProfileCreating.execute(r, FakeController.new)
    end

    trait :approved do
      after(:create) do |m|
        m.approved!
        a = m.account
        a.location_confirmed = true
        a.save!
      end
    end
  end

  factory :judge_profile, aliases: [:judge, :judge_account] do
    company_name { "FactoryBot" }
    job_title { "Engineer" }

    transient do
      email nil
      first_name "Judge"
      onboarded false
      virtual true
    end

    trait :geocoded do
      after(:create) do |j, _|
        Geocoding.perform(j.account).with_save
      end
    end

    before(:create) do |j, e|
      attrs = {}

      if e.onboarded
        attrs = {
          city: "Chicago",
          state_province: "IL",
          country: "US",
          location_confirmed: true,
        }
      end

      act_attrs = FactoryBot.attributes_for(:account).merge(attrs)

      j.build_account(act_attrs.merge(
        email: e.email || act_attrs[:email],
        first_name: e.first_name,
      ))

      if e.onboarded
        j.account.build_consent_waiver({
          electronic_signature: "test",
        })
      end
    end

    after(:create) do |j, e|
      ProfileCreating.execute(j, FakeController.new)
    end
  end
end
