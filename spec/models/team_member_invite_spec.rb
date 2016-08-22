require "rails_helper"

RSpec.describe TeamMemberInvite do
  it "prevents duplicate pending invites for the same team" do
    original_invite = FactoryGirl.create(:team_member_invite)

    invite = FactoryGirl.build(:team_member_invite,
                               team_id: original_invite.team_id,
                               invitee_email: original_invite.invitee_email)

    expect(invite).not_to be_valid
    expect(invite.errors[:invitee_email]).to eq(["has already been invited by your team."])
  end

  it "allows another pending invite for previously accepted invite" do
    original_invite = FactoryGirl.create(:team_member_invite, status: :accepted)

    invite = FactoryGirl.build(:team_member_invite,
                               team_id: original_invite.team_id,
                               invitee_email: original_invite.invitee_email)

    expect(invite).to be_valid
  end
end
