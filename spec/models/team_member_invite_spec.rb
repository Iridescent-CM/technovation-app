require "rails_helper"

RSpec.describe TeamMemberInvite do
  it "prevents duplicate pending invites for the same team" do
    original_invite = FactoryBot.create(:team_member_invite)

    invite = FactoryBot.build(:team_member_invite,
      team_id: original_invite.team_id,
      invitee_email: original_invite.invitee_email)

    expect(invite).not_to be_valid
    expect(invite.errors[:invitee_email]).to eq(["has already been invited by your team."])
  end

  it "allows another pending invite for previously accepted invite" do
    original_invite = FactoryBot.create(:team_member_invite, status: :accepted)

    invite = FactoryBot.build(:team_member_invite,
      team_id: original_invite.team_id,
      invitee_email: original_invite.invitee_email)

    expect(invite).to be_valid
  end

  it "declines other pending invites on acceptance" do
    invite1 = FactoryBot.create(:team_member_invite)
    invite2 = FactoryBot.create(:team_member_invite, invitee_email: invite1.invitee_email)

    invite1.accepted!
    expect(invite2.reload).to be_declined
  end
end
