require "rails_helper"

RSpec.feature "Students invite mentors to join their team" do
  before { SeasonToggles.team_building_enabled="yes" }

  let(:student) { FactoryGirl.create(:student, :geocoded, :on_team) }
  let!(:mentor) { FactoryGirl.create(:mentor, :geocoded) }

  before do
    sign_in(student)
    click_link "Find a mentor"
  end

  scenario "Invite an available mentor" do
    click_link "View Full Profile"
    click_button "Invite #{mentor.first_name} to mentor your team"
    expect(page).to have_content("Your team invite was sent!")
  end

  scenario "Find a mentor on your team" do
    TeamRosterManaging.add(student.team, mentor)
    click_link "View Full Profile"
    expect(page).to have_content("#{mentor.first_name} is a mentor on your team.")
  end

  scenario "Find a mentor you already invited" do
    student.team.mentor_invites.create!(
      invitee_email: mentor.email,
      inviter: student
    )
    click_link "View Full Profile"
    expect(page).to have_content("Your team has invited #{mentor.first_name}")
  end

  scenario "Find a mentor who already requested" do
    mentor.join_requests.create!(joinable: student.team)
    click_link "View Full Profile"
    expect(page).to have_content(
      "#{mentor.first_name} has requested to mentor your team"
    )
  end
end
