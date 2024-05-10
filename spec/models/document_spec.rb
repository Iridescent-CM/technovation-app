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
end
