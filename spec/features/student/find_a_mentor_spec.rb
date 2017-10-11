require "rails_helper"

RSpec.feature "Students invite mentors to join their team" do
  before { SeasonToggles.team_building_enabled="yes" }

  let(:student) { FactoryGirl.create(:student, :geocoded, :on_team) }
  let!(:mentor) { FactoryGirl.create(:mentor, :geocoded) }

  before do
    sign_in(student)
    visit student_team_path(student.team)
    click_link "Add a mentor"
  end

  scenario "Invite an available mentor" do
    click_link "Ask"
    click_button "Ask #{mentor.first_name}"
    expect(page).to have_content("Your team invite was sent!")
  end

  scenario "Find a mentor on your team" do
    TeamRosterManaging.add(student.team, mentor)
    click_link "Ask"
    expect(page).to have_content("#{mentor.first_name} is a mentor on your team.")
  end

  scenario "Find a mentor you already invited" do
    student.team.mentor_invites.create!(
      invitee_email: mentor.email,
      inviter: student
    )
    click_link "Ask"
    expect(page).to have_content("Your team has invited #{mentor.first_name}")
  end

  scenario "Find a mentor who already requested" do
    mentor.join_requests.create!(team: student.team)
    click_link "Ask"
    expect(page).to have_content(
      "#{mentor.first_name} has asked to mentor your team"
    )
  end

  scenario "Student is not yet on a team" do
    student.memberships.destroy_all

    visit student_dashboard_path

    within(".completion-step__find-mentor .step-actions") do
      expect(page).not_to have_link("Search for mentors")
      expect(page).to have_content(
        "When you are on a team, you will be able to search for mentors"
      )
    end
  end
end
