require "rails_helper"

RSpec.describe Admin::ChapterAmbassadorProfileAdditionsController do
  describe "POST #create" do
    let(:mentor_profile) { FactoryBot.create(:mentor) }
    let(:account) { mentor_profile.account }

    before do
      sign_in(:admin)

      post :create, params: {account_id: account.id}
      account.reload
    end

    it "adds a chapter ambassador profile to the account" do
      expect(account.chapter_ambassador_profile).to be_present
    end

    it "does not delete the account" do
      expect(account).to be_present
    end

    it "does not delete the mentor profile" do
      expect(mentor_profile).to be_present
    end
  end
end
