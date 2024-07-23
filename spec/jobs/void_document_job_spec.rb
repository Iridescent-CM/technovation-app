require "rails_helper"

RSpec.describe VoidDocumentJob do
  let(:document) { instance_double(Document, id: 341) }

  before do
    allow(Document).to receive(:find).with(document.id).and_return(document)
  end

  it "calls the DocuSign service that will void a document" do
    expect(Docusign::ApiClient).to receive_message_chain(:new, :void_document)
      .with(document)

    VoidDocumentJob.perform_now(document_id: document.id)
  end
end
