require "rails_helper"

RSpec.feature "Invite a member to a team" do
  let(:student) { FactoryGirl.create(:student, :on_team) }

  before do
    sign_in(student)
    click_link "My team"
    click_link "Add members"

    fill_in "Email", with: "some@student.com"
    click_button "Send invite"
  end

  let(:invite) { TeamMemberInvite.last }

  scenario "the invitee email is set by the form" do
    expect(invite.invitee_email).to eq("some@student.com")
  end

  scenario "the inviter is the signed in student" do
    expect(invite.inviter_id).to eq(student.id)
  end

  scenario "the team is set to the student's current team" do
    expect(invite.team).to eq(student.team)
  end

  scenario "the team member invite email is sent" do
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq(["some@student.com"])
    expect(mail.from).to eq([student.email])
  end
end
