require "rails_helper"

RSpec.describe Mentor::ProfilesController do
  describe "PUT #update" do
    it "allows toggling in-person-only" do
      mentor = FactoryGirl.create(:mentor)
      sign_in(mentor)

      put :update, params: { id: mentor.id, mentor_profile: { virtual: false } }

      expect(mentor.reload).not_to be_virtual
    end
  end
end
