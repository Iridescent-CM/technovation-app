require "rails_helper"

RSpec.describe "RAs visiting a team page" do
  describe "Clicking through to the submission" do
    it "works" do
      team = FactoryBot.create(:team, :submitted)

      sign_in(:ra)
      visit regional_ambassador_team_path(team)
      click_link team.submission.app_name

      expect(current_path).to eq(regional_ambassador_team_submission_path(team.submission))
    end
  end
end