require "rails_helper"

RSpec.describe "Reviewing the pitch video" do
  context "as a student" do
    before do
      SeasonToggles.team_submissions_editable!

      student = FactoryBot.create(:student, :on_team)
      team = student.teams.last
      team.create_submission!(integrity_affirmed: true)

      sign_in(student)
      click_link "Submit your project"

      click_link "Pitch video"
    end

    it "adds an intermediary step before really saving the pitch video" do
      fill_in "Youtube", with: "youtube.com/watch?v=adGebPmRjxg"
      click_button "Next"
      expect(page).to have_xpath(
        "//iframe[@src='https://www.youtube.com/embed/adGebPmRjxg']"
      )

      click_link "go back"
      fill_in "Youtube", with: "https://vimeo.com/119811742"
      click_button "Next"
      expect(page).to have_xpath(
        "//iframe[@src='https://player.vimeo.com/video/119811742']"
      )

      visit student_dashboard_path
      click_link "Submit your project"
      click_link "Pitch"
      expect(page).to have_css(".pitch_video_link.incomplete")
    end

    it "saves after the intermediary step" do
      fill_in "Youtube", with: "youtube.com/watch?v=adGebPmRjxg"
      click_button "Next"
      click_button "Save"
      expect(page).to have_css(".pitch_video_link.complete")
    end
  end

  context "as a mentor" do
    before do
      SeasonToggles.team_submissions_editable!

      mentor = FactoryBot.create(:mentor, :on_team)
      FactoryBot.create(:submission, team: mentor.teams.first)

      sign_in(mentor)

      click_link "Submit your Project"
      click_link "Edit submission"
      click_link "Pitch video"
    end

    it "adds an intermediary step before really saving the pitch video" do
      fill_in "Youtube", with: "youtube.com/watch?v=adGebPmRjxg"
      click_button "Next"
      expect(page).to have_xpath(
        "//iframe[@src='https://www.youtube.com/embed/adGebPmRjxg']"
      )

      click_link "go back"
      fill_in "Youtube", with: "https://vimeo.com/119811742"
      click_button "Next"
      expect(page).to have_xpath(
        "//iframe[@src='https://player.vimeo.com/video/119811742']"
      )

      visit mentor_dashboard_path
      click_link "Submit your Project"
      click_link "Edit submission"
      click_link "Pitch"
      expect(page).to have_css(".pitch_video_link.incomplete")
    end

    it "saves after the intermediary step" do
      fill_in "Youtube", with: "youtube.com/watch?v=adGebPmRjxg"
      click_button "Next"
      click_button "Save"
      expect(page).to have_css(".pitch_video_link.complete")
    end
  end
end
