FactoryBot.define do
  factory :mentor_profile, aliases: [:mentor, :mentor_account] do
    account

    school_company_name { "FactoryBot" }
    job_title { "Engineer" }
    mentor_type { MentorProfile.mentor_types.keys.sample }
    bio "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet."

    transient do
      first_name "Mentor"
      last_name nil
      city "Chicago"
      state_province "IL"
      country "US"
      sequence(:email) { |n| "factory-mentor-#{n}@example.com" }
      password nil
      date_of_birth nil
      not_onboarded false
      number_of_teams 0
    end

    trait :onboarded do
      not_onboarded false
    end

    trait :onboarding do
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

    trait :geocoded do
      after(:create) do |m, _|
        Geocoding.perform(m.account).with_save
      end
    end

    before(:create) do |m, e|
      attrs = FactoryBot.attributes_for(:account)

      attrs.merge(
        skip_existing_password: true,
        date_of_birth: e.date_of_birth || attrs[:date_of_birth],
        city: e.city,
        state_province: e.state_province,
        country: e.country,
        first_name: e.first_name,
        last_name: e.last_name || attrs[:last_name],
        email: e.email || attrs[:email],
        password: e.password || attrs[:password],
      ).each do |k, v|
        m.account.send("#{k}=", v)
      end

      if m.requires_background_check? and not e.not_onboarded
        # TODO: not not_onboarded :/
        m.account.build_background_check(
          FactoryBot.attributes_for(:background_check)
        )
      end

      unless m.consent_signed? or e.not_onboarded
        m.account.build_consent_waiver(
          FactoryBot.attributes_for(:consent_waiver)
        )
      end
    end

    after(:create) do |m, e|
      ProfileCreating.execute(m, FakeController.new)

      e.number_of_teams.times do
        team = FactoryBot.create(:team, members_count: 0)
        FactoryBot.create(
          :team_membership,
          member: m,
          team: team
        )
      end
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
        team = FactoryBot.create(:team, members_count: 0)
        FactoryBot.create(
          :team_membership,
          member: m,
          team: team
        )
      end
    end

    trait :complete_submission do
      after(:create) do |mentor|
        FactoryBot.create(:submission, :complete, team: mentor.teams.last)
      end
    end

    trait :has_qf_scores do
      on_team
      complete_submission

      after(:create) do |mentor|
        submission = mentor.current_teams.last.submission
        raise "Submission is missing" unless submission.present?
        raise "Submission is incomplete" unless submission.complete?
        FactoryBot.create(:score, :quarterfinals, :complete, team_submission: submission)
      end
    end

    trait :on_junior_team do
      after(:create) do |m|
        team = FactoryBot.create(:team, :junior)
        FactoryBot.create(
          :team_membership,
          member: m,
          team: team
        )
      end
    end

    factory :onboarded_mentor
  end
end

