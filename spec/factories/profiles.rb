FactoryGirl.define do
  factory :student_profile, aliases: [:student, :student_account] do
    account

    school_name { "FactoryGirl High" }

    transient do
      geocoded "Chicago, IL"
      date_of_birth Date.today - 15.years
      email nil
    end

    after(:create) do |s, e|
      unless s.parental_consent.present?
        s.create_parental_consent!(FactoryGirl.attributes_for(:parental_consent))
      end

      s.account.update_attributes(
        geocoded: e.geocoded,
        date_of_birth: e.date_of_birth,
        email: e.email || s.email,
      )
    end

    trait :on_team do
      after(:create) do |s|
        team = FactoryGirl.create(:team, members_count: 0)
        FactoryGirl.create(:team_membership, member_type: "StudentProfile",
                                             member_id: s.id,
                                             joinable: team)
      end
    end

    trait :full_profile do
      parent_guardian_email "example@example.com"
      parent_guardian_name "Parenty McGee"
      school_name "My school"
    end
  end

  factory :mentor_profile, aliases: [:mentor, :mentor_account] do
    school_company_name { "FactoryGirl" }
    job_title { "Engineer" }
    bio "A complete bio"

    transient do
      geocoded "Chicago, IL"
      country nil
    end

    before(:create) do |m, e|
      attrs = FactoryGirl.attributes_for(:account)

      m.build_account(attrs.merge(
        geocoded: e.geocoded,
        country: e.country || attrs[:country],
      ))

      unless m.background_check.present?
        m.account.build_background_check(FactoryGirl.attributes_for(:background_check))
      end
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

  factory :regional_ambassador_profile, aliases: [:ambassador, :regional_ambassador, :ambassador_account, :regional_ambassador_account] do
    organization_company_name { "FactoryGirl" }
    job_title { "Engineer" }
    ambassador_since_year { Time.current.year }
    bio "A complete bio"

    account

    transient do
      geocoded "Chicago, IL"
      country nil
    end

    after(:create) do |r, e|
      r.account.update_attributes(
        geocoded: e.geocoded,
        country: e.country || r.account.country,
      )

      unless r.background_check.present?
        r.account.create_background_check!(FactoryGirl.attributes_for(:background_check))
      end
    end

    trait :approved do
      after(:create) do |m|
        m.approved!
      end
    end
  end

  factory :judge_profile, aliases: [:judge, :judge_account] do
    company_name { "FactoryGirl" }
    job_title { "Engineer" }
    association(:account)
  end
end
