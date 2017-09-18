require "rails_helper"

RSpec.feature "Mentors and invitations" do
  scenario "A mentor accepts an invitation" do
    team = FactoryGirl.create(:team)

    mentor = FactoryGirl.create(:mentor)

    invite = FactoryGirl.create(
      :mentor_invite,
      team: team,
      invitee: mentor,
      invitee_email: mentor.email
    )

    sign_in(mentor)
    visit mentor_mentor_invite_path(id: invite.invite_token)

    click_button "Accept"

    expect(team.reload.mentors).to eq([mentor])
  end
end
