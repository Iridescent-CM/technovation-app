require "rails_helper"

RSpec.describe VolunteerAgreement do
  let(:volunteer_agreement) do
    VolunteerAgreement.new(
      profile: FactoryBot.create(:club_ambassador),
      electronic_signature: volunteer_agreement_electronic_signature,
      created_at: volunteer_agreement_created_at,
      voided_at: volunteer_agreement_voided_at
    )
  end

  let(:volunteer_agreement_electronic_signature) { "Factory Bot Signature" }
  let(:volunteer_agreement_created_at) { Time.now }
  let(:volunteer_agreement_voided_at) { nil }

  describe "validations" do
    let(:volunteer_agreement_electronic_signature) { nil }

    it "requires an electronic_signature" do
      expect(volunteer_agreement).not_to be_valid
    end
  end

  describe "#signed_at" do
    context "when the volunteer agreement has been signed" do
      it "returns the created_at timestamp" do
        expect(volunteer_agreement.signed_at).to eq(volunteer_agreement.created_at)
      end
    end
  end

  describe "#signed?" do
    context "when the volunteer agreement has been not been voided" do
      it "returns true" do
        expect(volunteer_agreement.signed?).to eq(true)
      end
    end

    context "when the volunteer agreement has been been voided" do
      let(:volunteer_agreement_voided_at) { Time.current }

      it "returns false" do
        expect(volunteer_agreement.signed?).to eq(false)
      end
    end
  end
end

