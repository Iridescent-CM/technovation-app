require "rails_helper"

RSpec.describe RegionalAmbassador::SignupsController do
  describe "POST #create" do
    it "saves the bio" do
      controller.set_cookie(:signup_token, SignupAttempt.create!(email: "joe@example.com", status: SignupAttempt.statuses[:active]).signup_token)

      post :create,
        regional_ambassador_account: FactoryGirl.attributes_for(
          :regional_ambassador,
          regional_ambassador_profile_attributes: FactoryGirl.attributes_for(
            :regional_ambassador_profile, bio: "Hello, bio"
          ),
        )
      expect(RegionalAmbassadorAccount.last.bio).to eq("Hello, bio")
    end
  end
end
