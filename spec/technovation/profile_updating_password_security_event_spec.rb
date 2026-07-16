# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfileUpdating do
  describe "password changes" do
    it "records a password.changed security event" do
      student = FactoryBot.create(:student)
      account = student.account
      request = instance_double(ActionDispatch::Request, remote_ip: "127.0.0.1", user_agent: "RSpec")

      expect {
        described_class.execute(
          student,
          {
            account_attributes: {
              id: account.id,
              existing_password: "secret1234",
              password: "AnotherSecret9"
            }
          },
          request: request
        )
      }.to change {
        SecurityEvent.where(event_type: "password.changed", account_id: account.id).count
      }.by(1)
    end
  end
end
