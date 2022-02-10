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
          round: SeasonToggles.judging_round(full_name: true)
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
                           "Hello world!\n I have line breaks too"
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
          submission_type: "Mobile App",
          development_platform: "Swift or XCode",
          demo_video_link: "http://example.com/pitch",
          pitch_video_link: "http://example.com/pitch"
        )
      end
    end

    trait :thunkable do
      development_platform { "Thunkable" }
      thunkable_account_email { "user@thunkable.com" }
      thunkable_project_url { "https://x.thunkable.com/projects/abc123" }
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

    after(:create) do |team_submission|
      RegisterToCurrentSeasonJob.perform_now(team_submission)
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
      learning_journey { "Learning journey description" }
      pitch_video_link { "http://example.com/pitch" }
      demo_video_link { "http://example.com/demo" }
      submission_type { "Mobile App" }
      development_platform { "Swift or XCode" }

      after(:create) do |team_submission|
        team_submission.update_column(:source_code, "source_code.zip")
        team_submission.update_column(:business_plan, "business_plan.pdf")
        team_submission.update_column(:pitch_presentation, "slides.pdf")
        team_submission.screenshots.create!
        team_submission.screenshots.create!

        team_submission.reload.published!
      end
    end
  end
end
