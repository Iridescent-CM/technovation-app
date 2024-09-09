require "rails_helper"

RSpec.describe Admin::Chapters::OffPlatformChapterAffiliationAgreementController do
  describe "POST #create" do
    let(:chapter) { FactoryBot.create(:chapter) }

    before do
      chapter.affiliation_agreement.delete

      sign_in(:admin)
      post :create, params: {chapter_id: chapter.id, seasons_valid: 1}

      chapter.reload
    end

    it "creates an off-platform affiliation agreement for the chapter" do
      expect(chapter.affiliation_agreement).to be_present
      expect(chapter.affiliation_agreement.status).to eq("off-platform")
    end
  end
end
