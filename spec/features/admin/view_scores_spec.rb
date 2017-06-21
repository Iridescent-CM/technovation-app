require "rails_helper"

RSpec.feature "Admins view scores" do
  scenario "view QF scores" do
    judging_round = ENV.fetch("JUDGING_ROUND") { false }
    ENV["JUDGING_ROUND"] = "QF"

    submission = FactoryGirl.create(
      :submission,
      :complete,
      technical_checklist_attributes: {
        used_camera: true,
        used_camera_explanation: "We did it...",
      }
    )

    FactoryGirl.create(:submission_score, :complete, team_submission: submission)

    admin = FactoryGirl.create(:admin)
    sign_in(admin)

    click_link "Quarterfinals Scores"
    click_link "View details"

    expect(page).to have_content("earned 2 points")

    if judging_round
      ENV["JUDGING_ROUND"] = judging_round
    end
  end
  scenario "view SF scores"
end
