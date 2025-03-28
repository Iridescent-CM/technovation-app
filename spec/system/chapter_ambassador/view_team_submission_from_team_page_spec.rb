require "rails_helper"

RSpec.describe "Chapter ambassadors visiting a team page" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
  let(:team) { FactoryBot.create(:team, :submitted) }
  let(:student_in_chapter) do
    FactoryBot.create(
      :student,
      :chicago,
      :not_assigned_to_chapter,
      first_name: "Harmony",
      last_name: "Bear"
    )
  end
  let(:student_not_in_chapter) do
    FactoryBot.create(
      :student,
      :chicago,
      first_name: "Cheer",
      last_name: "Bear"
    )
  end

  before do
    student_in_chapter.chapterable_assignments.create(
      account: student_in_chapter.account,
      chapterable: chapter_ambassador.current_chapter,
      season: Season.current.year,
      primary: true
    )

    TeamRosterManaging.add(team, student_in_chapter)
    TeamRosterManaging.add(team, student_not_in_chapter)

    sign_in(chapter_ambassador)
    visit chapter_ambassador_team_path(team)
  end

  describe "Viewing students on a team" do
    it "displays a link for the student that belongs to the chapter ambassador's chapter" do
      expect(page).to have_link(student_in_chapter.full_name)
    end

    it "does not display a link for the student that does not belong to the chapter ambassador's chapter" do
      expect(page).not_to have_link(student_not_in_chapter.full_name)
    end
  end

  describe "Clicking through to the submission" do
    it "displays the submission" do
      click_link team.submission.app_name

      expect(current_path).to eq(chapter_ambassador_team_submission_path(team.submission))
    end
  end
end
