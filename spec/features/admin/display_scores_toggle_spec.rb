require "rails_helper"

RSpec.feature "Toggling display of scores" do
  context "Student dashboard" do
    let(:user) { FactoryBot.create(:student) }
    let(:sub) { FactoryBot.create(:submission, :junior, :complete) }
    let(:path) { student_dashboard_path }

    before do
      TeamRosterManaging.add(sub.team, user)
      sign_in(user)
    end

    scenario "display scores on" do
      SeasonToggles.display_scores_on!

      visit path

      expect(page).to have_content("Scores and Certificates")
      expect(page).to have_css(".button", text: "View your scores and certificates")
    end

    scenario "display scores off" do
      SeasonToggles.display_scores_off!

      visit path

      expect(page).not_to have_content("Scores and Certificates")
      expect(page).not_to have_css(".button", text: "View your scores and certificates")
    end
  end

  context "Mentor dashboard" do
    let(:user) { FactoryBot.create(:mentor) }
    let(:sub) { FactoryBot.create(:submission, :junior, :complete) }
    let(:path) { mentor_dashboard_path }

    before do
      TeamRosterManaging.add(sub.team, user)
      sign_in(user)
    end

    scenario "display scores on" do
      SeasonToggles.display_scores_on!
      visit path
      expect(page).to have_css("div.mentor-scores")
    end

    scenario "display scores off" do
      SeasonToggles.display_scores_off!
      visit path
      expect(page).not_to have_css("div.mentor-scores")
    end
  end
end
