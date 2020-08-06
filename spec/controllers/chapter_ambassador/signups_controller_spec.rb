require "rails_helper"

RSpec.describe ChapterAmbassador::SignupsController do
  describe "POST #create" do
    it "saves the bio" do
      set_signup_token({
        email: "joe@example.com",
        password: "secret1234",
      })

      post :create, params: {
        chapter_ambassador_profile: FactoryBot.attributes_for(
          :chapter_ambassador,
          bio: "Hello, bio",
          account_attributes: FactoryBot.attributes_for(:account),
        )
      }

      expect(flash[:success]).to eq("Welcome to Technovation!")
      expect(ChapterAmbassadorProfile.last.bio).to eq("Hello, bio")
    end
  end
end
