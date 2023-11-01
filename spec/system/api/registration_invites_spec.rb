require "rails_helper"

RSpec.describe "Registration Invites" do
  before do
    allow(RegistrationInviteCodeValidator).to receive_message_chain(:new, :call)
      .and_return(registration_invite_validator_response)
  end

  let(:registration_invite_validator_response) do
    double("registration_invite_validator_response",
      valid?: true,
      register_at_any_time?: true,
      profile_type: "student")
  end

  it "returns registration invite details" do
    get api_registration_invite_path(id: "someinvitecode")

    expect(JSON.parse(response.body)).to eq(
      {
        "isValid" => registration_invite_validator_response.valid?,
        "canRegisterAtAnyTime" => registration_invite_validator_response.register_at_any_time?,
        "profileType" => registration_invite_validator_response.profile_type
      }
    )
  end
end
