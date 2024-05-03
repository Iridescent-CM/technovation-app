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
end
