FactoryBot.define do
  factory :team_submission, aliases: [:submission] do
    integrity_affirmed true

    trait :semifinalist do
      contest_rank :semifinalist
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

        PitchPresentation.create!({
          uploaded_file: "pitch_slides.pdf",
          team_submission: sub
        })

        2.times do
          sub.screenshots.create!
        end
      end
    end
  end
end
