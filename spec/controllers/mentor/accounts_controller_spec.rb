require "rails_helper"

RSpec.describe Mentor::AccountsController do
  describe "PUT #update" do
    it "allows toggling in-person-only" do
      mentor = FactoryGirl.create(:mentor)
      sign_in(mentor)

      put :update, id: mentor.id, mentor_profile: { virtual: false }

      expect(mentor.reload).not_to be_virtual
    end
  end
end
