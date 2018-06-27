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

    trait :has_current_completion_certificate do
      quarterfinalist

      after(:create) do |student|
        FactoryBot.create(:certificate,
          cert_type: :completion,
          account: student.account
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
        unless s.team.present?
          team = FactoryBot.create(:team, members_count: 0)
          TeamCreating.execute(team, s, FakeController.new)
        end
      end
    end

    trait :onboarded do
      geocoded
      not_onboarded false
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
