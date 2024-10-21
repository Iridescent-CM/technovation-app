require "rails_helper"

RSpec.describe Admin::LegalDocumentsController do
  describe "PATCH #void" do
    let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
    let(:document) { FactoryBot.create(:document, signer: chapter_ambassador) }

    before do
      sign_in(:admin)

      allow(Document).to receive(:find).and_return(document)
      allow(VoidDocumentJob).to receive(:perform_later)
    end

    it "makes a call to find the document" do
      expect(Document).to receive(:find).with(document.id.to_s)

      patch :void, params: {legal_document_id: document.id}
    end

    it "makes a call to void the document" do
      expect(VoidDocumentJob).to receive(:perform_later).with(document_id: document.id)

      patch :void, params: {legal_document_id: document.id}
    end

    it "redirects to the admin legal documents datagrid" do
      patch :void, params: {legal_document_id: document.id}

      expect(response).to redirect_to(admin_legal_documents_path)
    end
  end
end
