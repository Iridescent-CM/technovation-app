class VoidDocumentJob < ActiveJob::Base
  queue_as :default

  def perform(document_id:)
    document = Document.find(document_id)

    Docusign::ApiClient.new.void_document(document)
  end
end
