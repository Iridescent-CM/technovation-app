require "rails_helper"

RSpec.describe Document do
  let(:document) { Document.new(signed_at: signed_at) }
  let(:signed_at) { Time.now }

  describe "#signed?" do
    context "when the document has a signed_at timestamp" do
      let(:signed_at) { 1.day.ago }

      it "returns true" do
        expect(document.signed?).to eq(true)
      end
    end

    context "when the document does not have a signed_at timestamp" do
      let(:signed_at) { nil }

      it "returns false" do
        expect(document.signed?).to eq(false)
      end
    end
  end

  context "callbacks" do
    let(:document) { FactoryBot.create(:document, signer: signer) }
    let(:signer) { FactoryBot.create(:chapter_ambassador) }

    context "#after_update" do
      it "makes a call to update the signer's onboarding status when the document is updated" do
        expect(signer).to receive(:update_onboarding_status)

        document.update(signed_at: Time.now)
      end
    end
  end
end
