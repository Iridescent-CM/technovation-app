require "rails_helper"

RSpec.describe Mentor::SignupsController do
  describe "POST #create" do
    it "saves the bio" do
      post :create,
        mentor_account: FactoryGirl.attributes_for(
          :mentor,
          mentor_profile_attributes: FactoryGirl.attributes_for(
                                       :mentor_profile, bio: "Hello, bio"
                                     ),
        )
      expect(MentorAccount.last.bio).to eq("Hello, bio")
    end
  end
end
