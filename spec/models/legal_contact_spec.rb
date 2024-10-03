require "rails_helper"

RSpec.describe LegalContact do
  describe "validations" do
    let(:legal_contact) { LegalContact.new(full_name: full_name, email_address: email_address) }
    let(:full_name) { "Tina Treegoat" }
    let(:email_address) { "tinat@example.com" }

    context "when a name and email address is provided" do
      let(:full_name) { "June Beaver" }
      let(:email_address) { "juneb@example.com" }

      it "is valid" do
        expect(legal_contact).to be_valid
      end
    end

    context "when a name is not provided" do
      let(:full_name) { "" }

      it "is not valid" do
        expect(legal_contact).not_to be_valid
      end
    end

    context "when an email address is not provided" do
      let(:email_address) { "" }

      it "is not valid" do
        expect(legal_contact).not_to be_valid
      end
    end
  end

  describe "#seasons_chapter_affiliation_agreement_is_valid_for" do
    let(:legal_contact) do
      FactoryBot.create(
        :legal_contact,
        season_chapter_affiliation_agreement_signed: season_chapter_affiliation_agreement_signed,
        season_chapter_affiliation_agreement_expires: season_chapter_affiliation_agreement_expires
      )
    end
    let(:season_chapter_affiliation_agreement_expires) { nil }

    context "when the Chapter Affiliation Agreement has been signed" do
      let(:season_chapter_affiliation_agreement_signed) { 2023 }
      let(:season_chapter_affiliation_agreement_expires) { 2025 }

      it "returns an array of seasons the Chapter Affiliation Agreement is valid for (the season it was signed plus two additional seasons)" do
        expect(legal_contact.seasons_chapter_affiliation_agreement_is_valid_for).to eq([2023, 2024, 2025])
      end
    end

    context "when the Chapter Affiliation Agreement has not been signed" do
      let(:season_chapter_affiliation_agreement_signed) { nil }

      it "returns an empty array" do
        expect(legal_contact.seasons_chapter_affiliation_agreement_is_valid_for).to eq([])
      end
    end
  end

  describe "#update_onboarding_status" do
    let(:chapter) { FactoryBot.create(:chapter) }
    let(:legal_contact) { FactoryBot.create(:legal_contact, chapter: chapter) }

    it "calls #update_onboarding_status on the legal contact's chapter" do
      expect(legal_contact.chapter).to receive(:update_onboarding_status)

      legal_contact.update_onboarding_status
    end
  end
end
