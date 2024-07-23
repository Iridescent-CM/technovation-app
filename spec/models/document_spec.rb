require "rails_helper"

RSpec.describe Document do
  let(:document) { Document.new(sent_at: sent_at) }
  let(:sent_at) { Time.now }

  describe "#sent?" do
    context "when the document has a sent_at timestamp" do
      let(:sent_at) { 1.day.ago }

      it "returns true" do
        expect(document.sent?).to eq(true)
      end
    end

    context "when the document does not have a sent_at timestamp" do
      let(:sent_at) { nil }

      it "returns false" do
        expect(document.sent?).to eq(false)
      end
    end
  end

  context "callbacks" do
    let(:document) do
      FactoryBot.create(:document,
        signer: signer,
        sent_at: sent_at,
        signed_at: signed_at,
        voided_at: voided_at)
    end
    let(:signer) { FactoryBot.create(:chapter_ambassador) }
    let(:sent_at) { nil }
    let(:signed_at) { nil }
    let(:voided_at) { nil }

    context "#before_update" do
      describe "#status" do
        context "when a document has been sent" do
          let(:sent_at) { Time.now }

          it "returns 'sent'" do
            expect(document.status).to eq("sent")
          end
        end

        context "when a document has been signed" do
          let(:signed_at) { Time.now }

          it "returns 'signed'" do
            expect(document.status).to eq("signed")
          end
        end

        context "when a document has been voided" do
          let(:voided_at) { Time.now }

          it "returns 'voided'" do
            expect(document.status).to eq("voided")
          end
        end
      end
    end

    context "#after_update" do
      it "makes a call to update the signer's onboarding status when the document is updated" do
        expect(signer).to receive(:update_onboarding_status)

        document.update(signed_at: Time.now)
      end
    end
  end
end
