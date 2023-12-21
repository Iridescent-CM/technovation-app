require "rails_helper"

RSpec.describe "Team Requests" do
  describe "Visiting the edit location page" do
    it "requires a current team" do
      team = FactoryBot.create(:team)

      sign_in(:mentor)

      get edit_mentor_team_location_path(team)
      expect(response).to redirect_to(mentor_dashboard_path)

      sign_out

      sign_in(:student)
      get edit_student_team_location_path(team)
      expect(response).to redirect_to(student_dashboard_path)
    end
  end
end
