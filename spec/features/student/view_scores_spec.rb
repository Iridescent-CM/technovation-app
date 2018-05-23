require "rails_helper"

RSpec.feature "Students view scores" do
  before do
    SeasonToggles.display_scores="yes"
  end

  scenario "view QF scores" do
    submission = FactoryBot.create(
      :submission,
      :complete,
      technical_checklist_attributes: {
        used_camera: true,
        used_camera_explanation: "We did it...",
      }
    )

    FactoryBot.create(:submission_score, :complete, team_submission: submission)

    sign_in(submission.team.students.sample)
    click_link "View your scores and certificates"

    expect(page).to have_content("earned 2 points")
  end

  scenario "view SF scores" do
    submission = FactoryBot.create(
      :submission,
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

    sign_in(submission.team.students.sample)
    click_link "View your scores and certificates"

    expect(page).to have_content("earned 2 points")
  end
end
