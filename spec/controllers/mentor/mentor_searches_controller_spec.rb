require "rails_helper"

RSpec.describe Mentor::MentorSearchesController do
  describe "GET #new" do
    it "does not include mentors who don't want to connect" do
      mentor = FactoryGirl.create(:mentor)
      find_mentor = FactoryGirl.create(:mentor)
      no_find = FactoryGirl.create(:mentor, connect_with_mentors: false)

      sign_in(mentor)

      get :new

      expect(assigns[:mentors]).to include(find_mentor)
      expect(assigns[:mentors]).not_to include(no_find)
    end
  end
end
