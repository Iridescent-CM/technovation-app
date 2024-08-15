require "rails_helper"

RSpec.describe Admin::ChapterAffiliationAgreementController do
  let(:chapter) { FactoryBot.create(:chapter) }

  before do
    sign_in(:admin)
  end

  describe "POST #create" do
    context "when an affilation agreement does not exist for the chapter" do
      before do
        chapter.affiliation_agreement.delete
      end

      it "calls the job tht will send an affiliation agreement to the chapter" do
        expect(SendChapterAffiliationAgreementJob).to receive(:perform_later)
          .with(
            chapter_id: chapter.id
          )

        post :create, params: {chapter_id: chapter.id}
      end
    end

    context "when an affiliation agreement already exists for the chapter" do
      before do
        chapter.legal_contact.documents.create(
          full_name: chapter.legal_contact.full_name,
          email_address: chapter.legal_contact.email_address,
          docusign_envelope_id: "asdf-jkl;-0987"
        )
      end

      it "does not call the job that sends chapter affiliation agreements" do
        expect(SendChapterAffiliationAgreementJob).not_to receive(:perform_later)

        post :create, params: {chapter_id: chapter.id}
      end
    end
  end
end
