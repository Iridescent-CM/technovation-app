require "rails_helper"

RSpec.feature "Student creates a team" do
  scenario "Location is set automatically" do
    SeasonToggles.team_building_enabled!

    student = FactoryBot.create(:student, :full_profile)

    sign_in(student)

    within(".sub-nav-wrapper") { click_link "Create your team" }
    fill_in "Team name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.create",
      thing: I18n.t("models.team.class_name"))

    expect(Team.last.city).to eq(student.city)
  end

  scenario "Re-using a past team name" do
    SeasonToggles.team_building_enabled!

    student = FactoryBot.create(:student, :full_profile)
    old_team = FactoryBot.create(:team, name: "Awesomest Saucesests")
    old_team.update(seasons: [Season.current.year - 1])
    TeamRosterManaging.add(old_team, student)

    sign_in(student)

    within(".sub-nav-wrapper") { click_link "Create your team" }
    fill_in "Team name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.create",
      thing: I18n.t("models.team.class_name"))

    expect(page).to have_content("Your team has been created")
  end

  scenario "Re-using someone else's past team name" do
    SeasonToggles.team_building_enabled!

    student = FactoryBot.create(:student, :full_profile)
    old_team = FactoryBot.create(:team, name: "Awesomest Saucesests")
    old_team.update(seasons: [Season.current.year - 1])

    sign_in(student)

    within(".sub-nav-wrapper") { click_link "Create your team" }
    fill_in "Team name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.create",
      thing: I18n.t("models.team.class_name"))

    expect(page).to have_content("has already been taken")
  end
end
