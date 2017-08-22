require "rails_helper"

RSpec.feature "Students leave their own team" do
  before { SeasonToggles.team_building_enabled="yes" }

  scenario "leave the team" do
    student = FactoryGirl.create(:student, :on_team)

    sign_in(student)
    click_link "My team"

    click_link "remove this member"
    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_link("Register your team")
  end
end
