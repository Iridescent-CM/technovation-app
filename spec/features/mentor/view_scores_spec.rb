require "rails_helper"

RSpec.feature "Mentors view scores" do
  before { SeasonToggles.display_scores_on! }

  scenario "view QF scores" do
    team = FactoryBot.create(:team)
    mentor = FactoryBot.create(:mentor, :onboarded)

    TeamRosterManaging.add(team, mentor)

    submission = FactoryBot.create(
      :submission,
      :complete,
      team: team,
    )

    FactoryBot.create(:submission_score, :complete, team_submission: submission)

    sign_in(mentor)
    click_link("View details")

    expect(page).to have_title("Review Score")
  end

  scenario "view SF scores" do
    team = FactoryBot.create(:team)
    mentor = FactoryBot.create(:mentor, :onboarded)

    TeamRosterManaging.add(team, mentor)

    submission = FactoryBot.create(
      :submission,
      :complete,
      :semifinalist,
      team: team,
    )

    FactoryBot.create(
      :score,
      :complete,
      round: :semifinals,
      team_submission: submission
    )

    sign_in(mentor)
    click_link("View details")

    expect(page).to have_title("Review Score")
  end
end
