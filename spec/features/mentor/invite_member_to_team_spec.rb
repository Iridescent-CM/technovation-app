require "rails_helper"

RSpec.feature "Invite a member to a team" do
  before do
    SeasonToggles.team_building_enabled!
    Timecop.freeze(ImportantDates.quarterfinals_judging_begins - 1.day)
  end

  after do
    Timecop.return
  end

  let(:mentor) { FactoryBot.create(:mentor, :onboarded, :on_team) }

  let!(:incomplete_student) {
    FactoryBot.create(
      :student,
      not_onboarded: true,
      account: FactoryBot.create(:account, email: "incomplete@student.com")
    )
  }

  let!(:complete_student) {
    FactoryBot.create(
      :student,
      :geocoded,
      account: FactoryBot.create(:account, email: "complete@student.com")
    )
  }

  before do
    sign_in(mentor)

    within("#find-team #team_#{mentor.current_teams.first.id}") do
      click_link mentor.team_names.first
    end

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

    click_link "Open this invitation"
    expect(page).to have_content("Chicago, Illinois, United States")

    click_button "Accept invitation to #{mentor.team_names.first}"
    expect(current_path).to eq(student_dashboard_path)
  end

  scenario "complete student accepts invite" do
    fill_in "team_member_invite[invitee_email]", with: "complete@student.com"
    click_button "Send invite"

    sign_out
    sign_in(invite.invitee)

    click_link "Open this invitation"
    expect(page).to have_content("Chicago, Illinois, United States")

    click_button "Accept invitation to #{mentor.team_names.first}"
    expect(current_path).to eq(student_team_path(invite.team))
  end
end
