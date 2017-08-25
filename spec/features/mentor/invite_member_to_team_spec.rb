require "rails_helper"

RSpec.feature "Invite a member to a team" do
  before { SeasonToggles.team_building_enabled="yes" }

  let(:mentor) { FactoryGirl.create(:mentor, :on_team) }

  let!(:incomplete_student) {
    FactoryGirl.create(
      :student,
      not_onboarded: true,
      email: "incomplete@student.com"
    )
  }

  let!(:complete_student) {
    FactoryGirl.create(:student, email: "complete@student.com")
  }

  before do
    sign_in(mentor)
    within(".navigation") { click_link "My teams" }
    click_link mentor.team_names.first

    fill_in "team_member_invite[invitee_email]", with: "incomplete@student.com"
    click_button "Send invite"
  end

  let(:invite) { TeamMemberInvite.last }

  scenario "the invitee email is set by the form" do
    expect(invite.invitee_email).to eq("incomplete@student.com")
  end

  scenario "the invitee is set to the existing account" do
    expect(invite.invitee_id).to eq(incomplete_student.id)
  end

  scenario "the inviter is the signed in mentor" do
    expect(invite.inviter_id).to eq(mentor.id)
  end

  scenario "the team is set to the mentor's current team" do
    expect(invite.team).to eq(mentor.teams.last)
  end

  scenario "the team member invite email is sent" do
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq(["incomplete@student.com"])
    expect(mail.from).to eq(["mailer@technovationchallenge.org"])
  end

  scenario "incomplete student accepts invite" do
    sign_out
    sign_in(invite.invitee)

    click_link "View invitation"
    expect(page).to have_content("Chicago, IL, United States")

    click_button "Accept invitation to #{mentor.team_names.first}"
    expect(current_path).to eq(student_dashboard_path)
  end

  scenario "complete student accepts invite" do
    within(".navigation") { click_link "My teams" }
    click_link mentor.team_names.first

    fill_in "team_member_invite[invitee_email]", with: "complete@student.com"
    click_button "Send invite"

    sign_out
    sign_in(invite.invitee)

    click_link "View invitation"
    expect(page).to have_content("Chicago, IL, United States")

    click_button "Accept invitation to #{mentor.team_names.first}"
    expect(current_path).to eq(student_team_path(invite.team))
  end
end
