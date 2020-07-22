require "rails_helper"

RSpec.describe "chapter ambassadors visiting a team page" do
  describe "Clicking through to the submission" do
    it "works" do
      team = FactoryBot.create(:team, :submitted)

      sign_in(:chapter_ambassador)
      visit chapter_ambassador_team_path(team)
      click_link team.submission.app_name

      expect(current_path).to eq(chapter_ambassador_team_submission_path(team.submission))
    end
  end
end
