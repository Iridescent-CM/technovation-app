require "rails_helper"

RSpec.describe Student::TeamsController do
  describe 'POST #create' do
    it "creates teams for students not on a team" do
      student = FactoryGirl.create(:student)
      controller.set_cookie(:auth_token, student.auth_token)

      expect {
        post :create, team: { name: "Girl Power",
                              description: "We are a great team" }
      }.to change { Team.count }.from(0).to 1

      expect(student.team).to eq(Team.last)
    end

    it "does not create teams for students already on a team" do
      student = FactoryGirl.create(:student, :on_team)
      controller.set_cookie(:auth_token, student.auth_token)

      expect {
        post :create, team: { name: "Girl Power",
                              description: "We are a great team" }
      }.not_to change { Team.count }

      expect(flash[:alert]).to eq("You cannot create a new team if you are already on a team")
    end
  end

  describe "GET #new" do
    it "doesn't allow a student on a team to visit" do
      student = FactoryGirl.create(:student, :on_team)
      controller.set_cookie(:auth_token, student.auth_token)

      get :new
      expect(flash[:alert]).to eq("You cannot create a new team if you are already on a team")
    end
  end
end
