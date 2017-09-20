require "rails_helper"

RSpec.describe RegionalAmbassador::SignupsController do
  describe "POST #create" do
    it "saves the bio" do
      set_signup_token({
        email: "joe@example.com",
        password: "secret1234",
      })

      post :create, params: { regional_ambassador_profile: FactoryGirl.attributes_for(
        :regional_ambassador,
        bio: "Hello, bio",
        account_attributes: FactoryGirl.attributes_for(:account),
      ) }

      expect(flash[:success]).to eq("Welcome to Technovation!")
      expect(RegionalAmbassadorProfile.last.bio).to eq("Hello, bio")
    end
  end
end
