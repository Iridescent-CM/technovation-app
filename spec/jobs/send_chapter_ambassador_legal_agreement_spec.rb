require "rails_helper"

RSpec.describe SendChapterAmbassadorLegalAgreementJob do
  let(:chapter_ambassador_profile) { instance_double(ChapterAmbassadorProfile, id: 532) }

  before do
    allow(ChapterAmbassadorProfile).to receive(:find).with(chapter_ambassador_profile.id).and_return(chapter_ambassador_profile)
  end

  it "calls the DocuSign service that will send the legal agreement" do
    expect(Docusign::ApiClient).to receive_message_chain(:new, :send_chapter_ambassador_legal_agreement)
      .with(chapter_ambassador_profile: chapter_ambassador_profile)

    SendChapterAmbassadorLegalAgreementJob.perform_now(chapter_ambassador_profile_id: chapter_ambassador_profile.id)
  end
end
