require "rails_helper"

RSpec.feature "Students leave their own team" do
  scenario "leave the team" do
    student = FactoryGirl.create(:student, :on_team)
    sign_in(student)
    click_link "My team"
    click_link "Leave #{student.team_name}"
    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_link("Create a team")
  end
end
