require "rails_helper"

RSpec.describe SeasonSetup::ChapterAmbassadorOnboardingResetter do
  let(:chapter_ambassdor_onboarding_resetter) { SeasonSetup::ChapterAmbassadorOnboardingResetter.new }
  let!(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

  describe "#call" do
    it "resets the chapter ambassador's training timestamp" do
      chapter_ambassdor_onboarding_resetter.call

      expect(chapter_ambassador.reload.training_completed_at).to eq(nil)
    end

    it "resets the chapter ambassador's community connections flag" do
      chapter_ambassdor_onboarding_resetter.call

      expect(chapter_ambassador.reload.viewed_community_connections).to eq(false)
    end

    it "resets the chapter ambassador's onboarding flag" do
      chapter_ambassdor_onboarding_resetter.call

      expect(chapter_ambassador.reload.onboarded).to eq(false)
    end
  end
end
