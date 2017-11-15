require "rails_helper"

RSpec.describe UserInvitation do
  it "validates the email against an existing user" do
    FactoryBot.create(:student, email: " heLLo@world.com ")

    invite = UserInvitation.new(
      profile_type: :student,
      email: "  Hello@WORLD.com     ",
    )

    expect(invite).not_to be_valid
    expect(invite.errors[:email]).to include(
      "An account already exists with that email"
    )
  end
end
