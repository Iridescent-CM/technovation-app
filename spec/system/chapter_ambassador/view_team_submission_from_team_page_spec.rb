require "rails_helper"

RSpec.describe "chapter ambassadors visiting a team page" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

  describe "Clicking through to the submission" do
    it "works" do
      team = FactoryBot.create(:team, :submitted)

      affiliated_student = FactoryBot.create(:student, :chicago, :not_assigned_to_chapter)
      affiliated_student.chapterable_assignments.create(
        account: affiliated_student.account,
        chapterable: chapter_ambassador.current_chapter,
        season: Season.current.year
      )
      TeamRosterManaging.add(team, affiliated_student)

      sign_in(chapter_ambassador)
      visit chapter_ambassador_team_path(team)
      click_link team.submission.app_name

      expect(current_path).to eq(chapter_ambassador_team_submission_path(team.submission))
    end
  end
end
