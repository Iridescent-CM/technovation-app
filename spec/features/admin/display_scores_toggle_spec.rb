require "rails_helper"

RSpec.feature "Toggling display of scores" do
  context "Student dashboard" do
    let(:user) { FactoryBot.create(:student, :has_qf_scores) }

    before { sign_in(user) }

    scenario "display scores on" do
      SeasonToggles.display_scores_on!

      visit student_scores_path

      expect(page).to have_content("Before you can view your scores and certificates, please complete the post-season survey.")
    end

    scenario "display scores on and survey link set" do
      SeasonToggles.display_scores_on!
      SeasonToggles.set_survey_link(:student, "Hello World", "https://google.com")

      visit student_scores_path

      expect(page).to have_content("Before you can view your scores and certificates, please complete the post-season survey.")
      expect(page).to have_selector(:link_or_button, "Complete Survey")
    end

    scenario "display scores off" do
      SeasonToggles.display_scores_off!

      visit student_scores_path

      expect(page).to have_content("Reading your scores and certificates is not available right now.")
    end
  end

  context "Mentor dashboard" do
    let(:user) { FactoryBot.create(:mentor, :onboarded, :has_qf_scores) }

    before { sign_in(user) }

    scenario "display scores on" do
      SeasonToggles.display_scores_on!
      visit mentor_dashboard_path
      expect(page).to have_link("View Scores & Certificates")
    end

    scenario "display scores off" do
      SeasonToggles.display_scores_off!
      visit mentor_scores_path
      expect(page).to have_content("Reading your scores and certificates is not available right now.")
    end
  end
end
