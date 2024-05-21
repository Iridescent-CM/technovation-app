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

  describe "#seasons_legal_agreement_is_valid_for" do
    let(:legal_contact) do
      FactoryBot.create(:legal_contact, season_legal_document_signed: season_legal_document_signed)
    end

    context "when the legal agreement has been signed" do
      let(:season_legal_document_signed) { 2023 }

      it "returns an array of seasons the legal agreement is valid for (the season it was signed plus two additional seasons)" do
        expect(legal_contact.seasons_legal_agreement_is_valid_for).to eq([2023, 2024, 2025])
      end
    end

    context "when the legal agreement has not been signed" do
      let(:season_legal_document_signed) { nil }

      it "returns an empty array" do
        expect(legal_contact.seasons_legal_agreement_is_valid_for).to eq([])
      end
    end
  end
end
