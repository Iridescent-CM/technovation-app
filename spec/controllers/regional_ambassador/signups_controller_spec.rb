require "rails_helper"

RSpec.describe RegionalAmbassador::SignupsController do
  describe "POST #create" do
    it "saves the bio" do
      controller.set_cookie(
        :signup_token,
        SignupAttempt.create!(email: "joe@example.com",
                              password: "secret1234",
                              status: SignupAttempt.statuses[:active]).signup_token
      )

      post :create, params: { regional_ambassador_profile: FactoryGirl.attributes_for(
        :regional_ambassador,
        bio: "Hello, bio",
        account_attributes: FactoryGirl.attributes_for(:account),
      ) }

      expect(RegionalAmbassadorProfile.last.bio).to eq("Hello, bio")
    end
  end
end
