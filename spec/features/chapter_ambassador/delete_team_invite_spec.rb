require "rails_helper"

RSpec.feature "Chapter Ambsssadors deleting a team invite", :js do
  let!(:team) { FactoryBot.create(:team) }
  let!(:invite) { FactoryBot.create(:team_member_invite, :pending, team: team) }

  scenario "Deleting a team invite and displaying a confirmation message" do
    sign_in(:chapter_ambassador, :approved)

    click_link "Teams"
    within("tr#team_#{team.id}") { click_link "view" }

    expect(page).to have_content(invite.invitee_email)
    expect(team.team_member_invites).to be_one

    click_link "Delete invitation"
    click_button "Yes, do it"

    expect(page).to have_content("You deleted the invitation to #{invite.invitee_email}")
    expect(team.team_member_invites).to be_blank
  end
end
