require "rails_helper"

RSpec.describe SeasonSetup::ClubAmbassadorOnboardingResetter do
  let(:club_ambassdor_onboarding_resetter) { SeasonSetup::ClubAmbassadorOnboardingResetter.new }
  let!(:club_ambassador) { FactoryBot.create(:club_ambassador) }

  describe "#call" do
    it "resets the club ambassador's training timestamp" do
      club_ambassdor_onboarding_resetter.call

      expect(club_ambassador.reload.training_completed_at).to eq(nil)
    end

    it "resets the club ambassador's community connections flag" do
      club_ambassdor_onboarding_resetter.call

      expect(club_ambassador.reload.viewed_community_connections).to eq(false)
    end

    it "resets the club ambassador's onboarding flag" do
      club_ambassdor_onboarding_resetter.call

      expect(club_ambassador.reload.onboarded).to eq(false)
    end
  end
end
