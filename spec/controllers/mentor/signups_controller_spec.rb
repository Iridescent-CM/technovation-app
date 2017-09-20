require "rails_helper"

RSpec.describe Mentor::SignupsController do
  describe "POST #create" do
    it "saves the bio" do
      set_signup_token

      post :create, params: {
        mentor_profile: FactoryGirl.attributes_for(
          :mentor,
          bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet."
        ).merge(
          account_attributes: FactoryGirl.attributes_for(:account)
        )
      }

      expect(flash[:success]).to eq("Welcome to Technovation!")
      expect(MentorProfile.last.bio).to eq("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut diam vel felis fringilla amet.")
    end
  end
end
