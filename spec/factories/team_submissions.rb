FactoryGirl.define do
  factory :team_submission, aliases: [:submission] do

    team 

    integrity_affirmed true

    trait :complete do
      app_name "Submission name"
      app_description "Submission description"
      pitch_video_link "http://example.com/pitch"
      demo_video_link "http://example.com/demo"
      source_code_external_url "http://example.com/demo"

      after(:create) do |sub|
        BusinessPlan.create!({
          remote_file_url: "http://example.org/businessplan",
          team_submission: sub
        })

        PitchPresentation.create!({
          remote_file_url: "http://example.org/pitch",
          team_submission: sub
        })
      end
    end
  end
end
