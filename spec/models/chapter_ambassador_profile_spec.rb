require "rails_helper"

RSpec.describe ChapterAmbassadorProfile do
  let(:chapter_ambassador_profile) do
    FactoryBot.create(:chapter_ambassador_profile, viewed_community_connections: true)
  end

  describe "#full_name" do
    it "returns the full name on the account" do
      expect(chapter_ambassador_profile.full_name).to eq(chapter_ambassador_profile.account.full_name)
    end
  end

  describe "#email_address" do
    it "returns the email address on the account" do
      expect(chapter_ambassador_profile.email_address).to eq(chapter_ambassador_profile.account.email)
    end
  end

  describe "#legal_document_signed?" do
    before do
      allow(chapter_ambassador_profile).to receive_message_chain(:legal_document, :signed?).and_return(document_signed)
    end

    context "when the legal document has been signed" do
      let(:document_signed) { true }

      it "returns true" do
        expect(chapter_ambassador_profile.legal_document_signed?).to eq(true)
      end
    end

    context "when the legal document has not been signed" do
      let(:document_signed) { false }

      it "returns false" do
        expect(chapter_ambassador_profile.legal_document_signed?).to eq(false)
      end
    end
  end

  context "callbacks" do
    context "#after_update" do
      describe "updating the onboarded status" do
        before do
          allow(chapter_ambassador_profile).to receive(:account)
            .and_return(account)

          allow(account).to receive(:background_check)
            .and_return(background_check)

          allow(chapter_ambassador_profile).to receive(:legal_document)
            .and_return(legal_document)
        end

        let(:account) { instance_double(Account, email_confirmed?: email_address_confirmed, marked_for_destruction?: false, valid?: true,  background_check_exemption?: false) }
        let(:email_address_confirmed) { true }
        let(:background_check) { instance_double(BackgroundCheck, clear?: background_check_cleared) }
        let(:background_check_cleared) { true }
        let(:legal_document) { instance_double(Document, signed?: legal_document_signed) }
        let(:legal_document_signed) { true }

        context "when all onboarding steps have been completed" do
          let(:email_address_confirmed) { true }
          let(:background_check_cleared) { true }
          let(:legal_document_signed) { true }

          before do
            chapter_ambassador_profile.update(viewed_community_connections: true)
          end

          it "returns true" do
            expect(chapter_ambassador_profile.onboarded?).to eq(true)
          end
        end

        context "when the background check has not been cleared" do
          let(:background_check_cleared) { false }

          before do
            chapter_ambassador_profile.save
          end

          it "returns false" do
            expect(chapter_ambassador_profile.onboarded?).to eq(false)
          end
        end

        context "when the legal document has not been signed" do
          let(:legal_document_signed) { false }

          before do
            chapter_ambassador_profile.save
          end

          it "returns false" do
            expect(chapter_ambassador_profile.onboarded?).to eq(false)
          end
        end

        context "when training has not been completed" do
          before do
            chapter_ambassador_profile.update(training_completed_at: false)
          end

          it "returns false" do
            expect(chapter_ambassador_profile.onboarded?).to eq(false)
          end
        end

        context "when the community connections page has not been viewed" do
          before do
            chapter_ambassador_profile.update(viewed_community_connections: false)
          end

          it "returns false" do
            expect(chapter_ambassador_profile.onboarded?).to eq(false)
          end
        end
      end
    end
  end
end
