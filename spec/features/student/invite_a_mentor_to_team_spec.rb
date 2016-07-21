require "rails_helper"

RSpec.feature "Invite a mentor to join a team" do
  let!(:mentor) { FactoryGirl.create(:mentor) }

  let(:student) { FactoryGirl.create(:student, :on_team) }

  before do
    sign_in(student)
    click_link "Find a mentor"
    click_link mentor.full_name
    click_button "Invite to team"
  end

  scenario "Find and invite a mentor" do
    expect(current_path).to eq(student_team_path(student.team))
    expect(page).to have_css('.pending_invitees', text: mentor.email)
  end

  scenario "mentor accepts invite" do
    sign_in(mentor)
    visit mentor_mentor_invite_path(MentorInvite.last)
    click_button "Accept invitation to #{student.team_name}"
    expect(current_path).to eq(mentor_team_path(Team.last))
  end
end
