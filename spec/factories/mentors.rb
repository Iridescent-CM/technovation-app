FactoryBot.define do
  factory :mentor_profile, aliases: [:mentor, :mentor_account] do
    account

    school_company_name { "FactoryBot" }
    job_title { "Engineer" }
    mentor_type { MentorProfile.mentor_types.keys.sample }
    bio { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet." }

    transient do
      first_name { "Mentor" }
      last_name { nil }
      city { "Chicago" }
      state_province { "IL" }
      country { "US" }
      sequence(:email) { |n| "factory-mentor-#{n}@example.com" }
      password { nil }
      date_of_birth { nil }
      not_onboarded { false }
      number_of_teams { 0 }
    end

    trait :past do
      onboarded
      before(:create) do |mentor, _eval|
        mentor.account.seasons = [Season.current.year - 1]
      end
    end

    trait :onboarded do
      not_onboarded { false }
      training_completed_at { Time.current }
    end

    trait :onboarding do
      training_completed_at { nil }
    end

    trait :searchable_by_other_mentors do
      connect_with_mentors { true }
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
      after(:create) do |m, _|
        Geocoding.perform(m.account).with_save
      end
    end

    before(:create) do |m, e|
      {
        skip_existing_password: true,
        date_of_birth: e.date_of_birth || 22.years.ago,
        city: e.city,
        state_province: e.state_province,
        country: e.country,
        first_name: e.first_name,
        last_name: e.last_name || "FactoryBot",
      }.each do |k, v|
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
      onboarded

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

    trait :submitted do
      after(:create) do |mentor|
        FactoryBot.create(:submission, team: mentor.teams.last)
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

    trait :has_judge_profile do
      after(:create) do |mentor|
        CreateJudgeProfile.(mentor.account)
      end
    end

    factory :onboarded_mentor
  end
end

