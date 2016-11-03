FactoryGirl.define do
  factory :student_profile, aliases: [:student, :student_account] do
    school_name { "FactoryGirl High" }
    association(:account, date_of_birth: Date.today - 15.years)

    after(:create) do |s|
      unless s.parental_consent.present?
        s.create_parental_consent!(FactoryGirl.attributes_for(:parental_consent))
      end
    end

    after(:create) do |s|
      unless s.honor_code_signed?
        s.create_honor_code_agreement!(
          agreement_confirmed: true,
          electronic_signature: "Agreement Poodle"
        )
      end
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

    association(:account)
    association(:background_check)

    after(:create) do |m|
      unless m.honor_code_signed?
        m.create_honor_code_agreement!(
          agreement_confirmed: true,
          electronic_signature: "Agreement Hippo"
        )
      end

      unless m.consent_signed?
        m.create_consent_waiver(FactoryGirl.attributes_for(:consent_waiver))
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

    association(:account)
    association(:background_check)

    after(:create) do |r|
      unless r.consent_signed?
        r.create_consent_waiver(FactoryGirl.attributes_for(:consent_waiver))
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

    after(:create) do |j|
      unless j.consent_signed?
        j.create_consent_waiver(FactoryGirl.attributes_for(:consent_waiver))
      end
    end
  end
end
