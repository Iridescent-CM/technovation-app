require "rails_helper"

RSpec.feature "Mentor creates a team" do
  scenario "Re-using a past team name" do
    SeasonToggles.team_building_enabled!

    mentor = FactoryBot.create(:mentor, :onboarded, :geocoded)
    old_team = FactoryBot.create(:team, name: "Awesomest Saucesests")
    old_team.update(seasons: [Season.current.year - 1])
    TeamRosterManaging.add(old_team, mentor)

    sign_in(mentor)

    click_link "Create your team"
    fill_in "Team name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.create",
                        thing: I18n.t("models.team.class_name"))

    expect(page).to have_content("Your team has been created")
  end

  scenario "Re-using someone else's past team name" do
    SeasonToggles.team_building_enabled!

    mentor = FactoryBot.create(:mentor, :onboarded)
    old_team = FactoryBot.create(:team, name: "Awesomest Saucesests")
    old_team.update(seasons: [Season.current.year - 1])

    sign_in(mentor)

    click_link "Create your team"
    fill_in "Team name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.create",
                        thing: I18n.t("models.team.class_name"))

    expect(page).to have_content("has already been taken")
  end
end
