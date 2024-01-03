require "rails_helper"

RSpec.describe Mentor::TeamSubmissionsController do
  describe "PATCH #update" do
    before { SeasonToggles.team_submissions_editable! }

    it "can handle sorting" do
      mentor = FactoryBot.create(:mentor, :on_team, :onboarded)
      team_submission = FactoryBot.create(:submission, team: mentor.teams.first)

      screenshot1 = team_submission.screenshots.create!
      screenshot2 = team_submission.screenshots.create!

      sign_in(mentor)

      patch :update, params: {id: team_submission.id,
                              team_submission: {screenshots: [screenshot2.id, screenshot1.id]}}

      expect(screenshot1.reload.sort_position).to eq(1)
      expect(screenshot2.reload.sort_position).to eq(0)
    end
  end
end
