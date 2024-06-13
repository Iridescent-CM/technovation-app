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

  describe "#onboarded?" do
    before do
      allow(chapter_ambassador_profile).to receive(:account)
        .and_return(account)

      allow(account).to receive(:background_check)
        .and_return(background_check)

      allow(chapter_ambassador_profile).to receive(:legal_document)
        .and_return(legal_document)

      allow(chapter_ambassador_profile).to receive(:viewed_community_connections?)
        .and_return(viewed_community_connections)
    end

    let(:account) { instance_double(Account, email_confirmed?: email_address_confirmed) }
    let(:email_address_confirmed) { true }
    let(:background_check) { instance_double(BackgroundCheck, clear?: background_check_cleared) }
    let(:background_check_cleared) { true }
    let(:legal_document) { instance_double(Document, signed?: legal_document_signed) }
    let(:legal_document_signed) { true }
    let(:viewed_community_connections) { true }

    context "when all onboarding steps have been completed" do
      let(:email_address_confirmed) { true }
      let(:background_check_cleared) { true }
      let(:legal_document_signed) { true }
      let(:viewed_community_connections) { true }

      it "returns true" do
        expect(chapter_ambassador_profile.onboarded?).to eq(true)
      end
    end

    context "when the background check has not been cleared" do
      let(:background_check_cleared) { false }

      it "returns false" do
        expect(chapter_ambassador_profile.onboarded?).to eq(false)
      end
    end

    context "when the legal document has not been signed" do
      let(:legal_document_signed) { false }

      it "returns false" do
        expect(chapter_ambassador_profile.onboarded?).to eq(false)
      end
    end

    context "when the community connections page has not been viewed" do
      let(:viewed_community_connections) { false }

      it "returns false" do
        expect(chapter_ambassador_profile.onboarded?).to eq(false)
      end
    end
  end
end
