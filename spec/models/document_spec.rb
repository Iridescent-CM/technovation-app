require "rails_helper"

RSpec.describe Document do
  let(:document) do
    Document.new(
      status: document_status,
      signed_at: document_signed_at,
      signer_type: document_signer_type
    )
  end

  let(:document_status) { "voided" }
  let(:document_signer_type) { "LegalContact" }
  let(:document_signed_at) { nil }

  describe "#unsigned?" do
    context "when the document has been sent but not signed" do
      let(:document_status) { "sent" }
      let(:document_signed_at) { nil }

      it "returns true" do
        expect(document.unsigned?).to eq(true)
      end
    end

    context "when the document has been signed" do
      let(:document_status) { "signed" }

      it "returns false" do
        expect(document.unsigned?).to eq(false)
      end
    end
  end

  describe "#complete?" do
    context "when the document has been signed" do
      let(:document_status) { "signed" }

      it "returns true" do
        expect(document.complete?).to eq(true)
      end
    end

    context "when it's an off-platform document" do
      let(:document_status) { "off-platform" }

      it "returns true" do
        expect(document.complete?).to eq(true)
      end
    end

    context "when the document hasn't been signed and it's not an off-platform document" do
      let(:document_status) { "sent" }

      it "returns false" do
        expect(document.complete?).to eq(false)
      end
    end

    describe "#document_type" do
      context "when the signer type is a legal contact" do
        let(:document_signer_type) { "LegalContact" }

        it "returns 'Chapter Affiliation Agreement'" do
          expect(document.document_type).to eq("Chapter Affiliation Agreement")
        end
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
    let(:signer) { FactoryBot.create(:chapter_ambassador, :not_assigned_to_chapter) }
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

    context "#after_save" do
      let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :not_assigned_to_chapter) }

      it "makes a call to update the signer's onboarding status when an off-platform document is created" do
        expect(chapter_ambassador).to receive(:update_onboarding_status)

        Document.create(
          signer: chapter_ambassador,
          full_name: chapter_ambassador.full_name,
          email_address: chapter_ambassador.email,
          status: "off-platform"
        )
      end

      it "makes a call to update the signer's onboarding status when the document is updated" do
        expect(signer).to receive(:update_onboarding_status).at_least(:once)

        document.update(signed_at: Time.now)
      end
    end
  end
end
