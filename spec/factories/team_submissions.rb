FactoryBot.define do
  factory :team_submission, aliases: [:submission] do
    team

    integrity_affirmed true

    trait :semifinalist do
      contest_rank :semifinalist
    end

    after(:create) do |sub|
      RegisterToCurrentSeasonJob.perform_now(sub)
    end

    trait :complete do
      app_name "Submission name"
      app_description "Submission description"
      pitch_video_link "http://example.com/pitch"
      demo_video_link "http://example.com/demo"
      development_platform "Swift or XCode"

      after(:create) do |sub|
        sub.update_column(:source_code,  "source_code.zip")

        BusinessPlan.create!({
          uploaded_file: "business_plan.pdf",
          team_submission: sub
        })

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
