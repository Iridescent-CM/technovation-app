require "rails_helper"

RSpec.feature "Student updates a team" do
  let!(:student) { FactoryGirl.create(:student, :full_profile) }
  let!(:team) { FactoryGirl.create(:team) }

  before do
    SeasonToggles.team_building_enabled!
    TeamRosterManaging.add(team, student)
  end

  scenario "Re-using a past team name" do
    old_team = FactoryGirl.create(:team, name: "Awesomest Saucesests")
    old_team.update(seasons: [Season.current.year - 1])
    TeamRosterManaging.add(old_team, student)

    sign_in(student)

    visit edit_student_team_path(team)
    fill_in "Name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.save")

    expect(page).to have_content("Your team has been updated")
  end

  scenario "Re-using someone else's past team name" do
    old_team = FactoryGirl.create(:team, name: "Awesomest Saucesests")
    old_team.update(seasons: [Season.current.year - 1])

    sign_in(student)

    visit edit_student_team_path(team)
    fill_in "Name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.save")

    expect(page).to have_content("has already been taken")
  end
end
