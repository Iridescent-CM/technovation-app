require "rails_helper"

RSpec.describe MentorProfileSerializer do
  context "next onboarding step" do
    let(:mentor) { FactoryBot.create(:mentor, not_onboarded: true) }
    let(:next_onboarding_step) do
      serializer = MentorProfileSerializer.new(mentor.reload)
      h = serializer.serializable_hash
      h[:data][:attributes][:nextOnboardingStep]
    end

    it "sends user to training first" do
      expect(next_onboarding_step).to eq('mentor-training')
    end

    it "then to the consent waiver" do
      mentor.complete_training!

      expect(next_onboarding_step).to eq('consent-waiver')
    end

    it "then the background check, if required" do
      mentor.complete_training!
      FactoryBot.create(:consent_waiver, account: mentor.account)

      expect(next_onboarding_step).to eq('background-check')
    end

    it "then the bio" do
      mentor.complete_training!
      FactoryBot.create(:consent_waiver, account: mentor.account)
      FactoryBot.create(:background_check, account: mentor.account)

      expect(next_onboarding_step).to eq('bio')
    end
  end
end