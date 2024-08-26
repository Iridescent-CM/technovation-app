require "rails_helper"

RSpec.describe SendChapterVolunteerAgreementJob do
  let(:chapter_ambassador_profile) { instance_double(ChapterAmbassadorProfile, id: 532) }

  before do
    allow(ChapterAmbassadorProfile).to receive(:find).with(chapter_ambassador_profile.id).and_return(chapter_ambassador_profile)
  end

  it "calls the DocuSign service that will send the Chapter Volunteer Agreement" do
    expect(Docusign::ApiClient).to receive_message_chain(:new, :send_chapter_volunteer_agreement)
      .with(chapter_ambassador_profile: chapter_ambassador_profile)

    SendChapterVolunteerAgreementJob.perform_now(chapter_ambassador_profile_id: chapter_ambassador_profile.id)
  end
end
