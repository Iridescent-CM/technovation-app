require "rails_helper"

RSpec.feature "Admins view scores" do
  scenario "view QF scores" do
    submission = FactoryBot.create(
      :submission,
      :junior,
      :complete,
      technical_checklist_attributes: {
        used_camera: true,
        used_camera_explanation: "We did it...",
      }
    )

    FactoryBot.create(:submission_score, :complete, team_submission: submission)

    admin = FactoryBot.create(:admin)
    sign_in(admin)

    visit admin_scores_path
    click_link "View details"

    expect(page).to have_content("earned 2 points")
  end

  scenario "view SF scores" do
    skip "This is under construction"

    submission = FactoryBot.create(
      :submission,
      :junior,
      :complete,
      :semifinalist,
      technical_checklist_attributes: {
        used_camera: true,
        used_camera_explanation: "We did it...",
      }
    )

    FactoryBot.create(
      :score,
      :complete,
      round: :semifinals,
      team_submission: submission
    )

    admin = FactoryBot.create(:admin)
    sign_in(admin)

    visit admin_semifinals_scores_path
    click_link "View details"

    expect(page).to have_content("earned 2 points")
  end
end
