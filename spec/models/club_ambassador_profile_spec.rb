require "rails_helper"

RSpec.describe ClubAmbassadorProfile do
  let(:club_ambassador_profile) do
    FactoryBot.create(:club_ambassador_profile,
      training_completed_at: training_completed_at,
      viewed_community_connections: viewed_community_connections)
  end

  let(:training_completed_at) { Time.now }
  let(:viewed_community_connections) { true }

  context "callbacks" do
    context "#after_update" do
      describe "updating the onboarded status" do
        before do
          allow(club_ambassador_profile).to receive(:account)
            .and_return(account)

          allow(account).to receive(:background_check)
            .and_return(background_check)
        end

        let(:account) do
          instance_double(Account,
            country_code: "US",
            email_confirmed?: email_address_confirmed,
            background_check_exemption?: false,
            marked_for_destruction?: false,
            valid?: true)
        end

        let(:email_address_confirmed) { true }
        let(:background_check) { instance_double(BackgroundCheck, clear?: background_check_cleared) }
        let(:background_check_cleared) { true }

        context "when all onboarding steps have been completed" do
          let(:email_address_confirmed) { true }
          let(:background_check_cleared) { true }
          let(:training_completed_at) { Time.now }
          let(:viewed_community_connections) { true }

          before do
            club_ambassador_profile.save
          end

          it "returns true" do
            expect(club_ambassador_profile.onboarded?).to eq(true)
          end
        end

        context "when the background check has not been cleared" do
          let(:background_check_cleared) { false }

          before do
            club_ambassador_profile.save
          end

          it "returns false" do
            expect(club_ambassador_profile.onboarded?).to eq(false)
          end
        end

        context "when training has not been completed" do
          before do
            club_ambassador_profile.update(training_completed_at: false)
          end

          it "returns false" do
            expect(club_ambassador_profile.onboarded?).to eq(false)
          end
        end

        context "when the community connections page has not been viewed" do
          before do
            club_ambassador_profile.update(viewed_community_connections: false)
          end

          it "returns false" do
            expect(club_ambassador_profile.onboarded?).to eq(false)
          end
        end
      end
    end
  end

  describe "#chapterable_type" do
    it "returns club" do
      expect(ClubAmbassadorProfile.new.chapterable_type).to eq("club")
    end
  end
end
