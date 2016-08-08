require "rails_helper"

RSpec.describe Student::MentorSearchesController do
  describe "GET #new" do
    it "displays nearby mentors" do
      mentor = FactoryGirl.create(:mentor, :with_expertises)
      student = FactoryGirl.create(:student, :on_team)

      controller.set_cookie(:auth_token, student.auth_token)

      get :new

      expect(assigns[:mentors]).to eq([mentor])
    end
  end
end
