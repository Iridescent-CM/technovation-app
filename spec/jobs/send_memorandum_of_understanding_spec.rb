require "rails_helper"

RSpec.describe SendMemorandumOfUnderstandingJob do
  let(:chapter) { instance_double(Chapter, id: 146, legal_contact: legal_contact) }
  let(:legal_contact) { instance_double(LegalContact) }

  before do
    allow(Chapter).to receive(:find).with(chapter.id).and_return(chapter)
  end

  it "calls the DocuSign service that will send the memorandum of understanding" do
    expect(Docusign::ApiClient).to receive_message_chain(:new, :send_memorandum_of_understanding)
      .with(legal_contact: chapter.legal_contact)

    SendMemorandumOfUnderstandingJob.perform_now(chapter_id: chapter.id)
  end
end
