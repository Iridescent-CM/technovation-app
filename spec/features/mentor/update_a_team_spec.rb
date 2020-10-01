require "rails_helper"

RSpec.feature "Mentor updates a team" do
  let!(:mentor) { FactoryBot.create(:mentor, :onboarded, :geocoded) }
  let!(:team) { FactoryBot.create(:team) }

  before do
    SeasonToggles.team_building_enabled!
    TeamRosterManaging.add(team, mentor)
  end

  scenario "Re-using a past team name" do
    old_team = FactoryBot.create(:team, name: "Awesomest Saucesests")
    old_team.update(seasons: [Season.current.year - 1])
    TeamRosterManaging.add(old_team, mentor)

    sign_in(mentor)

    visit edit_mentor_team_path(team)
    fill_in "Team name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.save")

    expect(page).to have_content("Your team has been updated")
  end

  scenario "Re-using someone else's past team name" do
    old_team = FactoryBot.create(:team, name: "Awesomest Saucesests")
    old_team.update(seasons: [Season.current.year - 1])

    sign_in(mentor)

    visit edit_mentor_team_path(team)
    fill_in "Team name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.save")

    expect(page).to have_content("has already been taken")
  end
end
