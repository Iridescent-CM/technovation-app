require "rails_helper"

RSpec.feature "Admins view scores" do
  scenario "view QF scores" do
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

    visit admin_scores_path
    click_link "View details"

    expect(page).to have_content("earned 2 points")
  end

  scenario "view SF scores" do
    submission = FactoryGirl.create(
      :submission,
      :complete,
      :semifinalist,
      technical_checklist_attributes: {
        used_camera: true,
        used_camera_explanation: "We did it...",
      }
    )

    FactoryGirl.create(
      :score,
      :complete,
      round: :semifinals,
      team_submission: submission
    )

    admin = FactoryGirl.create(:admin)
    sign_in(admin)

    visit admin_semifinals_scores_path
    click_link "View details"

    expect(page).to have_content("earned 2 points")
  end
end
