require "rails_helper"

RSpec.feature "Student creates a team" do
  scenario "Location is set automatically" do
    SeasonToggles.team_building_enabled!

    student = FactoryGirl.create(:student, :full_profile)

    sign_in(student)

    within(".navigation") { click_link "Register your team" }
    fill_in "Name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.create",
                        thing: I18n.t("models.team.class_name"))

    expect(Team.last.city).to eq(student.city)
  end

  scenario "Location is a requirement when it hasn't been set on the student" do
    SeasonToggles.team_building_enabled!

    student = FactoryGirl.create(
      :student,
      city: nil,
      state_province: nil,
      country: nil,
      location_confirmed: false,
      not_onboarded: true,
    )

    sign_in(student)

    click_link "Register your team"
    fill_in "Name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.create",
                        thing: I18n.t("models.team.class_name"))

    team = Team.last
    expect(current_path).to eq(edit_student_team_location_path(team))

    fill_in "City", with: "Chicago"
    fill_in "State", with: "IL"
    select "United States", from: "Country"

    click_button "Save"

    expect(team.reload.city).to eq("Chicago")
    expect(student.reload.city).to eq("Chicago")

    expect(student.latitude).to eq(team.latitude)
    expect(student.account).to be_location_confirmed
  end
end
