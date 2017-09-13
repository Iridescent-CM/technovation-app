require "rails_helper"

RSpec.feature "Regional Ambassador views scores" do
  before do
    @ra_scores_enabled = ENV.fetch("ENABLE_RA_SCORES") { false }
    ENV["ENABLE_RA_SCORES"] = "yes"
    ra = FactoryGirl.create(:regional_ambassador, :approved)
    sign_in(ra)
  end

  after do
    if !!@ra_scores_enabled
      ENV["ENABLE_RA_SCORES"] = @ra_scores_enabled
    end
  end

  scenario "RA can't pick finals scores, as there is no such thing" do
    skip "please excuse the mess: rebuilding RA UI"
    click_link "Scores"
    options = page.find('[name=round]').all('option')
    expect(options.map(&:value)).not_to include("finals")
  end

  scenario "view QF scores" do
    skip "please excuse the mess: rebuilding RA UI"
    submission = FactoryGirl.create(
      :submission,
      :complete,
      technical_checklist_attributes: {
        used_camera: true,
        used_camera_explanation: "We did it...",
      }
    )

    FactoryGirl.create(:submission_score, :complete, team_submission: submission)

    click_link "Scores"
    click_link "View details"

    expect(page).to have_content("earned 2 points")
  end

  scenario "view SF scores" do
    skip "please excuse the mess: rebuilding RA UI"
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

    visit regional_ambassador_scores_path(round: :semifinals)
    click_link "View details"

    expect(page).to have_content("earned 2 points")
  end
end
