require "rails_helper"

RSpec.describe Admin::BackgroundCheckExemptionsController do
  describe "PATCH #grant" do
    let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
    let(:account) { chapter_ambassador.account }

    before do
      sign_in(:admin)

      patch :grant, params: {participant_id: account.id}
      account.reload
    end

    it "grants a background check exemption" do
      expect(account.background_check_exemption).to eq(true)
    end
  end

  describe "PATCH #revoke" do
    let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
    let(:account) { chapter_ambassador.account }

    before do
      sign_in(:admin)

      patch :revoke, params: {participant_id: account.id}
      account.reload
    end

    it "revokes the background check exemption" do
      expect(account.background_check_exemption).to eq(false)
    end
  end
end
