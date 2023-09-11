require "rails_helper"

RSpec.describe "Registration Invites" do
  before do
    allow(RegistrationInviteValidator).to receive_message_chain(:new, :call)
      .and_return(registration_invite_validator_response)
  end

  let(:registration_invite_validator_response) do
    double("registration_invite_validator_response",
      valid?: true,
      profile_type: "student",
      friendly_profile_type: "student")
  end

  it "returns registration invite details" do
    get api_registration_invite_path(id: "someinvitecode")

    expect(JSON.parse(response.body)).to eq(
      {
        "isValid" => registration_invite_validator_response.valid?,
        "profileType" => registration_invite_validator_response.profile_type,
        "friendlyProfileType" => registration_invite_validator_response.friendly_profile_type
      }
    )
  end
end
