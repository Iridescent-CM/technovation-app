require "rails_helper"

RSpec.describe VerifyWebhookPayload do
  let(:verify_webhook_payload) do
    VerifyWebhookPayload.new(
      payload: payload,
      secret: secret,
      signature: signature,
      logger: logger,
      error_notifier: error_notifier
    )
  end

  let(:payload) { {sample_payload: "xyz"}.to_json }
  let(:secret) { "abcd-45678-zyxw-3210" }
  let(:signature) { "sample signature" }
  let(:logger) { instance_double(ActiveSupport::Logger, error: true) }
  let(:error_notifier) { double("Airbrake") }

  before do
    allow(error_notifier).to receive(:notify)
  end

  describe "#call" do
    context "when the payload calculation matches the signature (making it a valid payload)" do
      let(:signature) { "BruvzqNcWfZi4V4tpdU1lQ4LBvpqxlJb/9x6BOlTdw0=" }

      it "returns a successful result" do
        expect(verify_webhook_payload.call.success?).to eq(true)
      end
    end

    context "when the payload calculation does not match the signature (making it an invalid payload)" do
      let(:signature) { "incorrect signature/1sBOlBdw7=" }

      it "returns an unsuccessful result" do
        expect(verify_webhook_payload.call.success?).to eq(false)
      end

      it "logs an error" do
        expect(logger).to receive(:error).with("[WEBHOOK PAYLOAD] Error verifying payload: #{payload}")

        verify_webhook_payload.call
      end

      it "sends an error via our error notifiter (Airbrake)" do
        expect(error_notifier).to receive(:notify).with("[WEBHOOK PAYLOAD] Error verifying payload: #{payload}")

        verify_webhook_payload.call
      end
    end
  end
end
