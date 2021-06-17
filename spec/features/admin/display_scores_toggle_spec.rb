require "rails_helper"

RSpec.feature "Toggling display of scores" do
  context "Student dashboard" do
    let(:user) { FactoryBot.create(:student, :has_qf_scores) }

    before { sign_in(user) }

    scenario "display scores on" do
      SeasonToggles.display_scores_on!

      visit student_dashboard_path

      expect(page).to have_content("Scores & Certificate")
      expect(page).to have_css(".button", text: "View your scores and certificate")
    end

    scenario "display scores off" do
      SeasonToggles.display_scores_off!

      visit student_dashboard_path

      expect(page).not_to have_content("Scores & Certificate")
      expect(page).not_to have_css(".button", text: "View your scores and certificate")
    end
  end

  context "Mentor dashboard" do
    let(:user) { FactoryBot.create(:mentor, :onboarded, :has_qf_scores) }

    before { sign_in(user) }

    scenario "display scores on" do
      SeasonToggles.display_scores_on!
      visit mentor_dashboard_path
      expect(page).to have_css("div.mentor-scores")
    end

    scenario "display scores off" do
      SeasonToggles.display_scores_off!
      visit mentor_dashboard_path
      expect(page).not_to have_css("div.mentor-scores")
    end
  end
end
