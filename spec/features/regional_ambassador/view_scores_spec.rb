require "rails_helper"

RSpec.feature "Regional Ambassador views scores" do
  before do
    ra = FactoryBot.create(:regional_ambassador, :approved)
    sign_in(ra)
  end

  scenario "RA can't pick finals scores, as there is no such thing" do
    click_link "Scores"
    options = page.find("[name='scored_submissions_grid[round]']").all('option')
    expect(options.map(&:value)).not_to include("finals")
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

    click_link "Scores"
    find('a.view-details').click

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

    visit regional_ambassador_scores_path(round: :semifinals)
    find('a.view-details').click

    expect(page).to have_content("earned 2 points")
  end
end
