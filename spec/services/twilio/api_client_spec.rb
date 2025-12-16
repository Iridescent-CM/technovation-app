require "rails_helper"

RSpec.describe Twilio::ApiClient do
  let(:twilio_api_client) do
    Twilio::ApiClient.new(
      api_account_sid: api_account_sid,
      api_auth_token: api_auth_token,
      technovation_phone_number: technovation_phone_number,
      host: host,
      logger: logger,
      error_notifier: error_notifier
    )
  end

  let(:api_account_sid) { "test_sid" }
  let(:api_auth_token) { "test_token" }
  let(:technovation_phone_number) { "+15555555555" }
  let(:host) { "test-technovation.org" }
  let(:twilio_client) { double("Twilio::REST::Client") }
  let(:messages) { double("messages") }
  let(:response) { double("response", sid: "test_sid_value", to: "+12223334444", status: "queued")}
  let(:logger) { double("Logger") }
  let(:error_notifier) { double("Airbrake") }

  let(:student_profile) {
    FactoryBot.create(
      :student_profile,
      parent_guardian_email: "email@email.com",
      parent_guardian_phone_number: "+11231231234"
    )
  }

  before do
    allow(Twilio::REST::Client).to receive(:new).and_return(twilio_client)
    allow(twilio_client).to receive(:messages).and_return(messages)
    allow(messages).to receive(:create).and_return(response)
  end

  describe "#send_parental_consent_text_message" do
    it "sends a parental consent text message" do
      expect(messages).to receive(:create)

      twilio_api_client.send_parental_consent_text_message(account: student_profile.account)
    end
  end
end

