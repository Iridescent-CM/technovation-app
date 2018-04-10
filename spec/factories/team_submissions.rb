FactoryBot.define do
  factory :team_submission, aliases: [:submission] do
    integrity_affirmed true

    team

    trait :semifinalist do
      contest_rank :semifinalist
    end

    trait :brazil do
      association(:team, factory: [:team, :brazil])
    end

    trait :los_angeles do
      association(:team, factory: [:team, :los_angeles])
    end

    trait :chicago do
      association(:team, factory: [:team, :chicago])
    end

    after(:create) do |sub|
      RegisterToCurrentSeasonJob.perform_now(sub)
    end

    trait :junior do
      association(:team, factory: [:team, :junior])
    end

    trait :senior do
      association(:team, factory: [:team, :senior])
    end

    trait :complete do
      app_name "Submission name"
      app_description "Submission description"
      pitch_video_link "http://example.com/pitch"
      demo_video_link "http://example.com/demo"
      development_platform "Swift or XCode"

      after(:create) do |sub|
        sub.update_column(:source_code,  "source_code.zip")
        sub.update_column(:business_plan,  "business_plan.pdf")
        sub.update_column(:pitch_presentation,  "slides.pdf")
        2.times { sub.screenshots.create! }
        sub.reload.published!
      end
    end
  end
end
