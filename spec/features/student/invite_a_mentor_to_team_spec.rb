require "rails_helper"

RSpec.feature "Invite a mentor to join a team" do
  scenario "Find and invite a mentor" do
    student = FactoryGirl.create(:student, :on_team)
    mentor = FactoryGirl.create(:mentor)

    sign_in(student)
    click_link "Find a mentor"
    click_link mentor.full_name
    click_button "Invite to team"

    expect(current_path).to eq(student_team_path(student.team))
    expect(page).to have_css('.pending_invitees', text: mentor.email)
  end
end
