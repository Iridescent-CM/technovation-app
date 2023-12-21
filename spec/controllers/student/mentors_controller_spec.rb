require "rails_helper"

RSpec.describe Student::MentorsController do
  describe "GET #show" do
    it "assigns the mentor" do
      mentor = FactoryBot.create(:mentor, :onboarded)
      student = FactoryBot.create(:student, :on_team)

      sign_in(student)
      get :show, params: {id: mentor.id}

      expect(assigns[:mentor]).to eq(mentor)
    end
  end
end
