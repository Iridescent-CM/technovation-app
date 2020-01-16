FactoryBot.define do
  factory :team_submission, aliases: [:submission] do
    integrity_affirmed { true }

    team

    transient do
      number_of_scores { 0 }
    end

    after(:create) do |submission, evaluator|
      evaluator.number_of_scores.times do
        FactoryBot.create(
          :score,
          :complete,
          team_submission: submission,
          ideation_1: Array(1..5).sample,
          round: SeasonToggles.judging_round(full_name: true),
        )
      end
    end

    trait :past_season do
      seasons { [Season.current.year - (1..10).to_a.sample] }
    end

    trait :incomplete do
      after(:create) do |submission|
        SubmissionValidation.invalidate(submission)
      end
    end

    trait :less_than_half_complete do
      after(:create) do |submission|
        SubmissionValidation.invalidate(submission)
        submission.update(
          app_name: "Filled in by the factory!",
          app_description: "Filled in by the factory! " +
                           "Hello world!\n I have line breaks too",
        )
      end
    end

    trait :half_complete do
      after(:create) do |submission|
        SubmissionValidation.invalidate(submission)
        submission.update(
          app_name: "Filled in by the factory!",
          app_description: "Filled in by the factory! " +
                           "Hello world!\n I have line breaks too",
          development_platform: "Swift or XCode",
          pitch_video_link: "http://example.com/pitch",
        )
      end
    end

    trait :thunkable do
      development_platform { "Thunkable" }
      thunkable_account_email { "user@thunkable.com" }
      thunkable_project_url { "https://x.thunkable.com/copy/abc123" }
    end

    trait :semifinalist do
      contest_rank { :semifinalist }
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
      app_name { "Submission name" }
      app_description { "Submission description" }
      pitch_video_link { "http://example.com/pitch" }
      development_platform { "Swift or XCode" }

      after(:create) do |sub|
        sub.update_column(:source_code,  "source_code.zip")
        sub.update_column(:business_plan,  "business_plan.pdf")
        sub.update_column(:pitch_presentation,  "slides.pdf")
        sub.reload.published!
      end
    end
  end
end
