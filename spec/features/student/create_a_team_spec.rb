require "rails_helper"

RSpec.feature "Student creates a team" do
  scenario "Location is set automatically" do
    SeasonToggles.team_building_enabled!
    SeasonToggles.team_submissions_editable!

    student = FactoryGirl.create(:student, :full_profile)

    sign_in(student)

    within(".navigation") { click_link "Register your team" }
    fill_in "Name", with: "Awesomest Saucesests"
    click_button I18n.t("views.application.create",
                        thing: I18n.t("models.team.class_name"))

    expect(Team.last.city).to eq(student.city)
  end
end
