# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::DeactivateInactiveAccounts do
  describe ".call" do
    it "deactivates inactive admins, regenerates auth tokens, and logs events" do
      inactive = FactoryBot.create(:admin)
      inactive.account.update_columns(last_logged_in_at: 91.days.ago, deactivated_at: nil)
      original_token = inactive.account.auth_token

      active = FactoryBot.create(:admin)
      active.account.update_columns(last_logged_in_at: 1.day.ago, deactivated_at: nil)

      already = FactoryBot.create(:admin)
      already.account.update_columns(
        last_logged_in_at: 91.days.ago,
        deactivated_at: 2.days.ago
      )

      expect {
        expect(described_class.call).to eq(1)
      }.to change { SecurityEvent.where(event_type: "admin.deactivated").count }.by(1)

      expect(inactive.account.reload.deactivated_at).to be_present
      expect(inactive.account.auth_token).not_to eq(original_token)
      expect(active.account.reload.deactivated_at).to be_nil
      expect(already.account.reload.deactivated_at).to be_within(1.second).of(2.days.ago)
    end
  end
end
