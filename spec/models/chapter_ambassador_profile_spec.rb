require "rails_helper"

RSpec.describe ChapterAmbassadorProfile do
  let(:chapter_ambassador_profile) { FactoryBot.create(:chapter_ambassador_profile) }

  describe "#full_name" do
    it "returns the full name on the account" do
      expect(chapter_ambassador_profile.full_name).to eq(chapter_ambassador_profile.account.full_name)
    end
  end

  describe "#email_address" do
    it "returns the email address on the account" do
      expect(chapter_ambassador_profile.email_address).to eq(chapter_ambassador_profile.account.email)
    end
  end

  describe "#legal_document_signed?" do
    before do
      allow(chapter_ambassador_profile).to receive_message_chain(:legal_document, :signed?).and_return(document_signed)
    end

    context "when the legal document has been signed" do
      let(:document_signed) { true }

      it "returns true" do
        expect(chapter_ambassador_profile.legal_document_signed?).to eq(true)
      end
    end

    context "when the legal document has not been signed" do
      let(:document_signed) { false }

      it "returns false" do
        expect(chapter_ambassador_profile.legal_document_signed?).to eq(false)
      end
    end
  end
end