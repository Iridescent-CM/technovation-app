require "rails_helper"

RSpec.feature "Chapter Ambsssadors deleting a team invite", :js do
  let(:team) { FactoryBot.create(:team) }

  before do
    sign_in(:chapter_ambassador, :approved)
  end

  scenario "Deleting a pending invite and displaying a confirmation message" do
    pending_invite = FactoryBot.create(:team_member_invite, :pending, team: team)

    click_link "Teams"
    within("tr#team_#{team.id}") { click_link "view" }

    expect(page).to have_content(pending_invite.invitee_email)
    expect(team.team_member_invites).to be_one

    click_link "Delete invitation"
    click_button "Yes, do it"

    expect(page).to have_content("You deleted the invitation to #{pending_invite.invitee_email}")
    expect(team.team_member_invites).to be_blank
  end

  scenario "Delete button does not appear for accepted invites" do
    accepted_invite = FactoryBot.create(:team_member_invite, :accepted, team: team)

    click_link "Teams"
    within("tr#team_#{team.id}") { click_link "view" }

    expect(page).to have_content(accepted_invite.invitee_email)
    expect(page).not_to have_button("Delete invitation")
  end

  scenario "Delete button does not appear for declined invites" do
    declined_invite = FactoryBot.create(:team_member_invite, :declined, team: team)

    click_link "Teams"
    within("tr#team_#{team.id}") { click_link "view" }

    expect(page).to have_content(declined_invite.invitee_email)
    expect(page).not_to have_button("Delete invitation")
  end
end
