require "rails_helper"

RSpec.describe Student::TeamSubmissionsController do
  describe "PATCH #update" do
    it "can handle sorting" do
      student = FactoryGirl.create(:student, :on_team)
      team_submission = student.team.team_submissions.create!(integrity_affirmed: true)

      screenshot1 = team_submission.screenshots.create!
      screenshot2 = team_submission.screenshots.create!

      sign_in(student)

      patch :update, params: { id: team_submission.id,
        team_submission: { screenshots: [screenshot2.id, screenshot1.id] } }

      expect(screenshot1.reload.sort_position).to eq(1)
      expect(screenshot2.reload.sort_position).to eq(0)
    end
  end
end
