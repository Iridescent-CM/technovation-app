require "rails_helper"

RSpec.describe Student::ScreenshotsController do
  describe "DELETE #destroy" do
    it "destroys screenshots by id" do
      student = FactoryBot.create(:student, :on_team)
      team_submission = FactoryBot.create(
        :team_submission,
        team: student.team
      )
      screenshot = team_submission.screenshots.create!

      sign_in(student)

      expect {
        delete :destroy, params: {id: screenshot.id}
      }.to change { Screenshot.count }.by(-1)
    end

    it "does not destroy screenshots that don't belong to the student" do
      student = FactoryBot.create(:student, :on_team)
      team_submission = FactoryBot.create(
        :team_submission,
        team: student.team
      )
      team_submission.screenshots.create!

      other_team = FactoryBot.create(:team)
      other_sub = FactoryBot.create(:team_submission, team: other_team)
      other = Screenshot.create!(team_submission: other_sub)

      sign_in(student)

      expect {
        delete :destroy, params: {id: other.id}
      }.not_to change { Screenshot.count }
    end
  end
end
