require "rails_helper"

RSpec.describe Student::ScreenshotsController do
  describe "DELETE #destroy" do
    it "destroys screenshots by id" do
      student = FactoryGirl.create(:student, :on_team)
      team_submission = student.team.team_submissions.create!(integrity_affirmed: true)
      screenshot = team_submission.screenshots.create!

      sign_in(student)

      expect {
        delete :destroy, params: { id: screenshot.id }
      }.to change { Screenshot.count }.by(-1)
    end

    it "does not destroy screenshots that don't belong to the student" do
      student = FactoryGirl.create(:student, :on_team)
      team_submission = student.team.team_submissions.create!(integrity_affirmed: true)
      team_submission.screenshots.create!

      other = Screenshot.create!

      sign_in(student)

      expect {
        delete :destroy, params: { id: other.id }
      }.not_to change { Screenshot.count }
    end
  end
end
