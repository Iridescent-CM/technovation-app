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

  it "validates the email against an existing RA" do
    ra = FactoryBot.create(:regional_ambassador)
    ra.account.create_mentor_profile!(FactoryBot.attributes_for(:mentor))

    invite = UserInvitation.new(
      profile_type: :regional_ambassador,
      email: ra.email
    )

    expect(invite).not_to be_valid
    expect(invite.errors[:email]).to include(
      "An account already exists with that email"
    )
  end

  %i{student mentor judge}.each do |type|
    it "validates the email against an existing mentor if the type is #{type}" do
      mentor = FactoryBot.create(:mentor)

      invite = UserInvitation.new(
        profile_type: type,
        email: mentor.email
      )

      expect(invite).not_to be_valid
      expect(invite.errors[:email]).to include(
        "An account already exists with that email"
      )
    end
  end

  it "allows an existing mentor to be moved for an RA" do
    mentor = FactoryBot.create(:mentor)

    invite = UserInvitation.new(
      profile_type: :regional_ambassador,
      email: mentor.email,
    )

    expect(invite).to be_valid
  end
end
