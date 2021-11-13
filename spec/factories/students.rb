FactoryBot.define do
  factory :student_profile, aliases: [:student, :student_account] do
    account

    school_name { "FactoryBot High" }

    transient do
      first_name { "Student" }
      last_name { "FactoryBot" }
      city { "Chicago" }
      state_province { "IL" }
      country { "US" }
      date_of_birth { Division.cutoff_date - (Division::SENIOR_DIVISION_AGE - 1).years }
      sequence(:email) { |n| "factory-student-#{n}@example.com" }
      password { "secret1234" }
      not_onboarded { false }
    end

    trait :past do
      after(:create) do |student, _evaluator|
        student.account.update_column(
          :seasons, [Season.current.year - 1]
        )

        student.parental_consents.update_all(seasons: [Season.current.year - 1])
      end
    end

    trait :returning do
      after(:create) do |student, _evaluator|
        student.account.update_column(
          :seasons, [Season.current.year, Season.current.year - 1]
        )
      end
    end

    trait :incomplete_submission do
      onboarded
      on_team

      after(:create) do |student|
        FactoryBot.create(:submission, :less_than_half_complete, team: student.team)
      end
    end

    trait :half_complete_submission do
      onboarded
      on_team

      after(:create) do |student|
        FactoryBot.create(:submission, :half_complete, team: student.team)
      end
    end

    trait :submitted do
      quarterfinalist
    end

    trait :virtual do
      after(:create) do |student|
        if student.team.present?
          student.team.events.destroy_all
        end
      end
    end

    trait :quarterfinalist do
      onboarded
      on_team

      after(:create) do |student|
        FactoryBot.create(:submission, :complete, team: student.team)
      end
    end

    trait :semifinalist do
      onboarded
      on_team

      after(:create) do |student|
        submission = FactoryBot.create(:submission, :complete, :semifinalist, team: student.team)
        FactoryBot.create(:score, :semifinals, :complete, team_submission: submission)
      end
    end

    trait :has_qf_scores do
      quarterfinalist

      after(:create) do |student|
        submission = student.team.submission
        raise "Submission is missing" unless submission.present?
        raise "Submission is incomplete" unless submission.complete?
        FactoryBot.create(:score, :quarterfinals, :complete, team_submission: submission)
      end
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

    trait :najran do
      city { "Najran" }
      state_province { "Najran Province" }
      country { "Saudi Arabia" }
    end

    trait :dhurma do
      city { "Dhurma" }
      state_province { "Riyadh Province" }
      country { "Saudi Arabia" }
    end

    trait :geocoded do
      before(:create) do |s, _|
        Geocoding.perform(s.account)
      end
    end

    before(:create) do |s, e|
      if e.not_onboarded
        s.build_parental_consent
        s.build_media_consent
      else
        s.build_parental_consent(
          FactoryBot.attributes_for(:parental_consent)
            .merge(status: :signed)
        )
      end

      {
        skip_existing_password: true,
        first_name: e.first_name,
        last_name: e.last_name,
        city: e.city,
        state_province: e.state_province,
        country: e.country,
        date_of_birth: e.date_of_birth,
      }.each do |k, v|
        s.account.send("#{k}=", v)
      end
    end

    after(:create) do |s, e|
      ProfileCreating.execute(s, FakeController.new)
    end

    trait :senior do
      date_of_birth { Division.cutoff_date - Division::SENIOR_DIVISION_AGE.years }

      after(:create) do |s|
        s.division = Division.senior
      end
    end

    trait :junior do
      date_of_birth { Division.cutoff_date - (Division::SENIOR_DIVISION_AGE - 1).years }

      after(:create) do |s|
        s.division = Division.junior
      end
    end

    trait :beginner do
      date_of_birth { Division.cutoff_date - 8.years }

      after(:create) do |s|
        s.division = Division.beginner
      end
    end

    trait :on_team do
      after(:create) do |s|
        unless s.team.present?
          team = FactoryBot.create(:team, members_count: 0)
          TeamCreating.execute(team, s, FakeController.new)
        end
      end
    end

    trait :onboarded do
      geocoded
      not_onboarded { false }
    end

    trait :full_profile do
      geocoded
      parent_guardian_email { "example@example.com" }
      parent_guardian_name { "Parenty McGee" }
      school_name { "My school" }
    end

    trait :onboarding do
      not_onboarded { true }
    end

    factory :onboarded_student, traits: [:full_profile]
    factory :onboarding_student, traits: [:onboarding]
  end
end
