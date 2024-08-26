require "rails_helper"

RSpec.describe ChapterAmbassador::ChapterVolunteerAgreementsController do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

  before do
    sign_in(chapter_ambassador)
  end

  describe "POST #create" do
    context "when a Chapter Volunteer Agreement does not exist for the chapter ambassador" do
      before do
        chapter_ambassador.chapter_volunteer_agreement.delete
      end

      it "calls the job tht will send a Chapter Volunteer Agreement to the chapter ambassador" do
        expect(SendChapterVolunteerAgreementJob).to receive(:perform_later)
          .with(
            chapter_ambassador_profile_id: chapter_ambassador.id
          )

        post :create
      end
    end

    context "when a Chapter Volunteer Agreement already exists for the chapter ambassador" do
      before do
        chapter_ambassador.documents.create(
          full_name: chapter_ambassador.full_name,
          email_address: chapter_ambassador.email,
          docusign_envelope_id: "xyz-123-abc-987"
        )
      end

      it "does not call the job that sends Chapter Volunteer Agreements" do
        expect(SendChapterVolunteerAgreementJob).not_to receive(:perform_later)

        post :create
      end
    end
  end
end
