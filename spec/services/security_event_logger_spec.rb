# frozen_string_literal: true

require "rails_helper"

RSpec.describe SecurityEventLogger do
  let(:account) { FactoryBot.create(:account) }
  let(:actor) { FactoryBot.create(:account) }
  let(:request) do
    instance_double(
      ActionDispatch::Request,
      remote_ip: "203.0.113.10",
      user_agent: "RSpec Test Agent"
    )
  end

  describe ".log" do
    it "persists a security event with account, actor, request, and metadata" do
      expect {
        described_class.log(
          event_type: "login.success",
          account: account,
          actor: actor,
          request: request,
          metadata: {source: "spec"}
        )
      }.to change(SecurityEvent, :count).by(1)

      event = SecurityEvent.last
      expect(event.event_type).to eq("login.success")
      expect(event.account).to eq(account)
      expect(event.actor_account).to eq(actor)
      expect(event.ip_address).to eq("203.0.113.10")
      expect(event.user_agent).to eq("RSpec Test Agent")
      expect(event.metadata).to eq("source" => "spec")
    end

    it "omits sensitive keys from metadata" do
      described_class.log(
        event_type: "password.changed",
        account: account,
        metadata: {
          password: "secret1234",
          password_confirmation: "secret1234",
          existing_password: "old-secret",
          note: "ok"
        }
      )

      expect(SecurityEvent.last.metadata).to eq("note" => "ok")
    end

    it "allows logging without an account or request" do
      described_class.log(
        event_type: "login.failure",
        metadata: {email: "unknown@example.com"}
      )

      event = SecurityEvent.last
      expect(event.account).to be_nil
      expect(event.ip_address).to be_nil
      expect(event.metadata).to eq("email" => "unknown@example.com")
    end
  end
end
