require "rails_helper"

RSpec.describe Mentor::SignupsController do
  describe "POST #create" do
    it "saves the bio" do
      controller.set_cookie(:signup_token, SignupAttempt.create!(email: "blah", status: SignupAttempt.statuses[:active]).signup_token)

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
