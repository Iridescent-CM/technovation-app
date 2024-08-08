require "rails_helper"

RSpec.describe SendChapterAffiliationAgreementJob do
  let(:chapter) { instance_double(Chapter, id: 146, legal_contact: legal_contact) }
  let(:legal_contact) { instance_double(LegalContact) }

  before do
    allow(Chapter).to receive(:find).with(chapter.id).and_return(chapter)
  end

  it "calls the DocuSign service that will send the chapter affiliation agreemenj" do
    expect(Docusign::ApiClient).to receive_message_chain(:new, :send_chapter_affiliation_agreement)
      .with(legal_contact: chapter.legal_contact)

    SendChapterAffiliationAgreementJob.perform_now(chapter_id: chapter.id)
  end
end
