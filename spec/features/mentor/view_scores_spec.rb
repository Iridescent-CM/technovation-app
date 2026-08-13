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
      team: team
    )

    FactoryBot.create(:submission_score, :complete, team_submission: submission)

    sign_in(mentor)
    click_link("View Scores & Certificates")

    expect(page).to have_content("View details")

    click_link("View details")

    expect(page).to have_content("Score Details")
    expect(page).to have_link("Back to scores", href: mentor_scores_path)

    click_link("Back to scores")

    expect(page).to have_current_path(mentor_scores_path)
    expect(page).to have_content("View details")
  end

  scenario "view SF scores" do
    team = FactoryBot.create(:team)
    mentor = FactoryBot.create(:mentor, :onboarded)

    TeamRosterManaging.add(team, mentor)

    submission = FactoryBot.create(
      :submission,
      :complete,
      :semifinalist,
      team: team
    )

    FactoryBot.create(
      :score,
      :complete,
      round: :semifinals,
      team_submission: submission
    )

    sign_in(mentor)
    click_link("View Scores & Certificates")

    expect(page).to have_content("View details")
  end

  scenario "not-onboarded mentor can view finished scores" do
    team = FactoryBot.create(:team)
    mentor = FactoryBot.create(:mentor, not_onboarded: true)

    TeamRosterManaging.add(team, mentor)

    submission = FactoryBot.create(
      :submission,
      :complete,
      team: team
    )

    FactoryBot.create(:submission_score, :complete, team_submission: submission)

    sign_in(mentor)
    click_link("View Scores & Certificates")

    expect(page).to have_content("View details")
    expect(page).to have_content(team.name)
    expect(page).not_to have_link(team.name, href: mentor_team_path(team))
    expect(page).not_to have_content("You must complete the mentor training")
    expect(page).not_to have_content("You need to sign the consent waiver")
  end
end
