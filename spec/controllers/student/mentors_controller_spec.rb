require "rails_helper"

RSpec.describe Student::MentorsController do
  describe "GET #show" do
    it "assigns the mentor" do
      mentor = FactoryGirl.create(:mentor)
      student = FactoryGirl.create(:student, :on_team)

      sign_in(student)
      get :show, id: mentor.id

      expect(assigns[:mentor]).to eq(mentor)
    end
  end
end
