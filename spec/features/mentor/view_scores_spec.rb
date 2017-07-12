require "rails_helper"

RSpec.feature "Mentors view scores" do
  before do
    SeasonToggles.display_scores="yes"
  end

  scenario "view QF scores" do
    team = FactoryGirl.create(:team)
    mentor = FactoryGirl.create(:mentor)

    TeamRosterManaging.add(team, mentor)

    submission = FactoryGirl.create(
      :submission,
      :complete,
      team: team,
      technical_checklist_attributes: {
        used_camera: true,
        used_camera_explanation: "We did it...",
      }
    )

    FactoryGirl.create(:submission_score, :complete, team_submission: submission)

    sign_in(mentor)
    click_link("View details")

    expect(page).to have_content("earned 2 points")
  end

  scenario "view SF scores" do
    team = FactoryGirl.create(:team)
    mentor = FactoryGirl.create(:mentor)

    TeamRosterManaging.add(team, mentor)

    submission = FactoryGirl.create(
      :submission,
      :complete,
      :semifinalist,
      team: team,
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

    sign_in(mentor)
    click_link("View details")

    expect(page).to have_content("earned 2 points")
  end
end
