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

  describe "#chapter_volunteer_agreement_complete?" do
    before do
      allow(chapter_ambassador_profile).to receive_message_chain(:chapter_volunteer_agreement, :complete?).and_return(document_completed)
    end

    context "when the legal document has been signed" do
      let(:document_completed) { true }

      it "returns true" do
        expect(chapter_ambassador_profile.chapter_volunteer_agreement_complete?).to eq(true)
      end
    end

    context "when the legal document has not been signed" do
      let(:document_completed) { false }

      it "returns false" do
        expect(chapter_ambassador_profile.chapter_volunteer_agreement_complete?).to eq(false)
      end
    end
  end

  describe "#incomplete_onboarding_tasks" do
    before do
      allow(chapter_ambassador_profile).to receive(:background_check_exempt_or_complete?).and_return(true)
      allow(chapter_ambassador_profile).to receive(:training_completed?).and_return(true)
      allow(chapter_ambassador_profile).to receive(:chapter_volunteer_agreement_complete?).and_return(true)
      allow(chapter_ambassador_profile).to receive(:viewed_community_connections?).and_return(true)
    end

    context "when all required onboarding tasks have been completed" do
      it "returns returns an empty array" do
        expect(chapter_ambassador_profile.incomplete_onboarding_tasks).to be_empty
      end
    end

    context "when the background check is incomplete" do
      before do
        allow(chapter_ambassador_profile).to receive(:background_check_exempt_or_complete?).and_return(false)
      end

      it "returns returns an array that contains 'Background Check'" do
        expect(chapter_ambassador_profile.incomplete_onboarding_tasks).to contain_exactly("Background Check")
      end
    end

    context "when the training is incomplete" do
      before do
        allow(chapter_ambassador_profile).to receive(:training_completed?).and_return(false)
      end

      it "returns returns an array that contains 'Chapter Ambassador Training'" do
        expect(chapter_ambassador_profile.incomplete_onboarding_tasks).to contain_exactly("Chapter Ambassador Training")
      end
    end

    context "when the Chapter Volunteer Agreement has not been signed" do
      before do
        allow(chapter_ambassador_profile).to receive(:chapter_volunteer_agreement_complete?).and_return(false)
      end

      it "returns returns an array that contains 'Chapter Volunteer Agreement'" do
        expect(chapter_ambassador_profile.incomplete_onboarding_tasks).to contain_exactly("Chapter Volunteer Agreement")
      end
    end

    context "when the community connections page has not been viewed" do
      before do
        allow(chapter_ambassador_profile).to receive(:viewed_community_connections?).and_return(false)
      end

      it "returns returns an array that contains 'Community Connections'" do
        expect(chapter_ambassador_profile.incomplete_onboarding_tasks).to contain_exactly("Community Connections")
      end
    end
  end

  describe "#chapterable_type" do
    it "returns chapter" do
      expect(ChapterAmbassadorProfile.new.chapterable_type).to eq("chapter")
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

          allow(chapter_ambassador_profile).to receive(:chapter_volunteer_agreement)
            .and_return(chapter_volunteer_agreement)
        end

        let(:account) { instance_double(Account, email_confirmed?: email_address_confirmed, marked_for_destruction?: false, valid?: true, background_check_exemption?: false) }
        let(:email_address_confirmed) { true }
        let(:background_check) { instance_double(BackgroundCheck, clear?: background_check_cleared) }
        let(:background_check_cleared) { true }
        let(:chapter_volunteer_agreement) { instance_double(Document, complete?: chapter_volunteer_agreement_complete) }
        let(:chapter_volunteer_agreement_complete) { true }

        context "when all onboarding steps have been completed" do
          let(:email_address_confirmed) { true }
          let(:background_check_cleared) { true }
          let(:chapter_volunteer_agreement_complete) { true }

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
          let(:chapter_volunteer_agreement_complete) { false }

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
