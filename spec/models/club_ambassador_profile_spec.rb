require "rails_helper"

RSpec.describe ClubAmbassadorProfile do
  let(:club_ambassador_profile) do
    FactoryBot.create(:club_ambassador_profile,
      training_completed_at: training_completed_at)
  end

  let(:training_completed_at) { Time.now }

  context "callbacks" do
    context "#after_update" do
      describe "updating the onboarded status" do
        before do
          allow(club_ambassador_profile).to receive(:account)
            .and_return(account)
        end

        let(:account) do
          instance_double(Account,
            email_confirmed?: email_address_confirmed,
            marked_for_destruction?: false,
            valid?: true)
        end

        let(:email_address_confirmed) { true }

        context "when all onboarding steps have been completed" do
          let(:email_address_confirmed) { true }

          it "returns true" do
            expect(club_ambassador_profile.onboarded?).to eq(true)
          end
        end

        context "when training has not been completed" do
          before do
            club_ambassador_profile.update(training_completed_at: false)
          end

          xit "returns false" do
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
