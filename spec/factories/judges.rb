FactoryBot.define do
  factory :judge_profile, aliases: [:judge, :judge_account] do
    account

    company_name { "FactoryBot" }
    job_title { "Engineer" }

    transient do
      sequence(:email) { |n| "factory-judge-#{n}@example.com" }
      first_name "Judge"
      onboarded false
      virtual true
      mentor false
    end

    trait :onboarded do
      onboarded true
    end

    trait :virtual do
    end

    trait :live_event_eligible do
    end

    trait :not_live_event_eligible do
      mentor true
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
        }

        j.training_completed_without_save!
        j.survey_completed_without_save!
      end

      act_attrs = FactoryBot.attributes_for(:account).merge(attrs)

      act_attrs.merge(
        skip_existing_password: true,
        email: e.email || act_attrs[:email],
        first_name: e.first_name,
      ).each do |k, v|
        j.account.send("#{k}=", v)
      end

      if e.onboarded
        j.account.build_consent_waiver({
          electronic_signature: "test",
        })
      end

      if e.mentor
        j.account.build_mentor_profile(FactoryBot.attributes_for(:mentor))
      end

      if e.onboarded && !j.can_be_marked_onboarded?
        raise "Judge should be onboarded but is not. Fix Factory"
      end
    end

    after(:create) do |j, e|
      ProfileCreating.execute(j, FakeController.new)
    end
  end
end
