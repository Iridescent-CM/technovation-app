FactoryGirl.define do
  factory :team_submission, aliases: [:submission] do

    team 

    integrity_affirmed true

    trait :complete do
      app_name "Submission name"
      app_description "Submission description"
      stated_goal TeamSubmission.stated_goals[:Environment]
      stated_goal_explanation "Save the whales"
      pitch_video_link "http://example.com/pitch"
      demo_video_link "http://example.com/demo"
      source_code_external_url "http://example.com/demo"
      development_platform TeamSubmission.development_platforms[:Java]

      after(:create) do |sub|
        if sub.team and sub.team.team_photo.blank?
          sub.team.update_column(:team_photo, "team.png")
        end

        2.times {
          screenshot = Screenshot.create!()
          screenshot.update_column(:image, "/img/screenshot.png")
          sub.screenshots << screenshot
        }

        BusinessPlan.create!({
          remote_file_url: "http://example.org/businessplan",
          team_submission: sub
        })

        PitchPresentation.create!({
          remote_file_url: "http://example.org/pitch",
          team_submission: sub
        })

        FactoryGirl.create(:technical_checklist, :completed, team_submission: sub)
      end
    end
  end
end
