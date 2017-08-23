FactoryGirl.define do
  factory :admin_profile, aliases: [:admin] do
    account
  end

  factory :student_profile, aliases: [:student, :student_account] do
    account

    school_name { "FactoryGirl High" }

    transient do
      city "Chicago"
      state_province "IL"
      country "US"
      date_of_birth Date.today - 15.years
      email nil
      password nil
    end

    trait :geocoded do
      after(:create) do |s, _|
        Geocoding.perform(s.account).with_save
      end
    end

    before(:create) do |s, e|
      if s.parental_consent.nil?
        s.build_parental_consent(FactoryGirl.attributes_for(:parental_consent))
      end

      attrs = FactoryGirl.attributes_for(:account)

      s.build_account(attrs.merge(
        city: e.city,
        state_province: e.state_province,
        country: e.country || attrs[:country],
        date_of_birth: e.date_of_birth,
        email: e.email || attrs[:email],
        password: e.password || attrs[:password],
      ))

      s.account.build_honor_code_agreement(FactoryGirl.attributes_for(:honor_code_agreement))
    end

    after(:create) do |s, e|
      RegisterToCurrentSeasonJob.perform_now(s.account)
    end

    trait :on_team do
      after(:create) do |s|
        team = FactoryGirl.create(:team)
        FactoryGirl.create(:team_membership, member_type: "StudentProfile",
                                             member_id: s.id,
                                             joinable: team)
      end
    end

    trait :full_profile do
      geocoded
      parent_guardian_email "example@example.com"
      parent_guardian_name "Parenty McGee"
      school_name "My school"
    end
  end

  factory :mentor_profile, aliases: [:mentor, :mentor_account] do
    school_company_name { "FactoryGirl" }
    job_title { "Engineer" }
    bio "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet."

    transient do
      first_name nil
      city "Chicago"
      state_province "IL"
      country "US"
      email nil
      password nil
    end

    trait :geocoded do
      after(:create) do |m, _|
        Geocoding.perform(m.account).with_save
      end
    end

    before(:create) do |m, e|
      attrs = FactoryGirl.attributes_for(:account)

      m.build_account(attrs.merge(
        city: e.city || attrs[:city] || "Chicago",
        state_province: e.state_province || attrs[:state_province] || "IL",
        country: e.country || attrs[:country],
        first_name: e.first_name || attrs[:first_name],
        email: e.email || attrs[:email],
        password: e.password || attrs[:password],
      ))

      unless m.background_check.present?
        m.account.build_background_check(FactoryGirl.attributes_for(:background_check))
      end

      unless m.consent_signed?
        m.account.build_consent_waiver(FactoryGirl.attributes_for(:consent_waiver))
      end

      unless m.honor_code_signed?
        m.account.build_honor_code_agreement(
          FactoryGirl.attributes_for(:honor_code_agreement)
        )
      end
    end

    after(:create) do |m, e|
      RegisterToCurrentSeasonJob.perform_now(m.account)
    end

    trait :with_expertises do
      after(:create) do |m|
        2.times do
          FactoryGirl.create(:expertise, mentor_profile_ids: m.id)
        end
      end
    end

    trait :on_team do
      after(:create) do |m|
        team = FactoryGirl.create(:team)
        FactoryGirl.create(:team_membership, member_type: "MentorProfile",
                                             member_id: m.id,
                                             joinable: team)
      end
    end
  end

  factory :regional_ambassador_profile, aliases: [
    :ambassador,
    :regional_ambassador,
    :ambassador_account,
    :regional_ambassador_account
  ] do
    organization_company_name { "FactoryGirl" }
    job_title { "Engineer" }
    ambassador_since_year { Time.current.year }
    bio "A complete bio"

    account

    transient do
      city "Chicago"
      state_province "IL"
      country "US"
      email nil
      password nil
      first_name nil
    end

    trait :geocoded do
      after(:create) do |r, _|
        Geocoding.perform(r.account).with_save
      end
    end

    before(:create) do |r, e|
      attrs = FactoryGirl.attributes_for(:account)

      r.build_account(attrs.merge(
        city: e.city,
        state_province: e.state_province,
        country: e.country || attrs[:country],
        email: e.email || attrs[:email],
        password: e.password || attrs[:password],
        first_name: e.first_name || attrs[:first_name],
      ))

      unless r.background_check.present?
        r.account.build_background_check(FactoryGirl.attributes_for(:background_check))
      end

      unless r.consent_signed?
        r.account.build_consent_waiver(FactoryGirl.attributes_for(:consent_waiver))
      end
    end

    after(:create) do |r, e|
      RegisterToCurrentSeasonJob.perform_now(r.account)
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
    company_name { "FactoryGirl" }
    job_title { "Engineer" }

    transient do
      email nil
      first_name nil
      full_access false
      virtual true
    end

    trait :geocoded do
      after(:create) do |j, _|
        Geocoding.perform(j.account).with_save
      end
    end

    before(:create) do |j, e|
      attrs = {}

      if e.full_access
        attrs = {
          city: "Chicago",
          state_province: "IL",
          country: "US",
          location_confirmed: true,
        }
      end

      act_attrs = FactoryGirl.attributes_for(:account).merge(attrs)

      j.build_account(act_attrs.merge(
        email: e.email || act_attrs[:email],
        first_name: e.first_name || act_attrs[:first_name],
      ))

      if e.full_access
        j.account.build_consent_waiver({
          electronic_signature: "test",
        })
      end
    end

    after(:create) do |j, e|
      RegisterToCurrentSeasonJob.perform_now(j.account)
    end
  end
end
