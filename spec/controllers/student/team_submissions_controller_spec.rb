require "rails_helper"

RSpec.describe Student::TeamSubmissionsController do
  describe "PATCH #update" do
    before do
      @editable_submissions = !!SeasonToggles.team_submissions_editable?
      SeasonToggles.team_submissions_editable = true
    end

    after do
      SeasonToggles.team_submissions_editable = @editable_submissions
    end

    it "can handle sorting" do
      student = FactoryGirl.create(:student, :on_team)
      team_submission = FactoryGirl.create(:submission, team: student.team)

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
