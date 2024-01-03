FactoryBot.define do
  factory :judge_profile, aliases: [:judge, :judge_account] do
    account

    company_name { "FactoryBot" }
    job_title { "Engineer" }

    transient do
      sequence(:email) { |n| "factory-judge-#{n}@example.com" }
      first_name { "Judge" }
      onboarded { false }
      virtual { true }
      mentor { false }
      city { "Chicago" }
      state_province { "IL" }
      country { "US" }
      number_of_scores { 0 }
    end

    trait :attending_live_event do
      onboarded

      after(:create) do |judge, _evaluator|
        event = FactoryBot.create(:event)
        event.judges << judge
      end
    end

    trait :general_certificate do
      onboarded

      after(:create) do |judge, _evaluator|
        FactoryBot.create(:score, :complete, judge_profile: judge)
      end
    end

    trait :certified_certificate do
      onboarded

      after(:create) do |judge, _evaluator|
        5.times do
          FactoryBot.create(:score, :complete, judge_profile: judge)
        end
      end
    end

    trait :onboarded do
      onboarded { true }
    end

    trait :virtual do
    end

    trait :live_event_eligible do
    end

    trait :not_live_event_eligible do
      mentor { true }
    end

    trait :geocoded do
      after(:create) do |j, _|
        Geocoding.perform(j.account).with_save
      end
    end

    trait :los_angeles do
      city { "Los Angeles" }
      state_province { "CA" }
      country { "US" }
    end

    trait :chicago do
      city { "Chicago" }
      state_province { "IL" }
      country { "US" }
    end

    before(:create) do |j, e|
      attrs = {
        city: e.city,
        state_province: e.state_province,
        country: e.country
      }

      if e.onboarded
        j.training_completed_without_save!
        j.survey_completed_without_save!
      end

      attrs.merge(
        skip_existing_password: true,
        first_name: e.first_name
      ).each do |k, v|
        j.account.send("#{k}=", v)
      end

      if e.onboarded
        j.account.build_consent_waiver({
          electronic_signature: "test"
        })
      end

      if e.mentor
        j.account.build_mentor_profile(FactoryBot.attributes_for(:mentor))
      end

      if e.onboarded && !j.can_be_marked_onboarded?
        raise "Judge should be onboarded but is not. Fix Factory"
      end
    end

    after(:create) do |judge, evaluator|
      ProfileCreating.execute(judge, FakeController.new)
      judge.reload

      evaluator.number_of_scores.times do
        FactoryBot.create(
          :score,
          :complete,
          judge_profile: judge,
          round: SeasonToggles.judging_round(full_name: true)
        )
      end
    end
  end
end
