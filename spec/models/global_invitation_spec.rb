require "rails_helper"

RSpec.describe GlobalInvitation do
  it "comes with a token" do
    expect(GlobalInvitation.create!.token).not_to be_nil
  end

  it "enums" do
    invite = GlobalInvitation.create!
    expect(invite).to be_active

    invite.deleted!
    expect(invite).to be_deleted
  end
end
