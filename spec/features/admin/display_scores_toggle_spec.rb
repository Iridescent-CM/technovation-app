require "rails_helper"

RSpec.feature "Toggling display of scores" do
  context "Student dashboard" do
    let(:user) { FactoryGirl.create(:student) }
    let(:sub) { FactoryGirl.create(:submission, :complete) }
    let(:path) { student_dashboard_path }

    before do
      TeamRosterManaging.add(sub.team, user)

      sign_in(user)
    end

    scenario "display scores on" do
      skip "Rebuilding student dashboard: scores not back yet"
      SeasonToggles.display_scores="on"
      visit path

      expect(page).to have_button("Scores")
      expect(page).to have_css("div.content div#scores")
    end

    scenario "display scores off" do
      skip "Rebuilding student dashboard: scores not back yet"
      SeasonToggles.display_scores="off"
      visit path

      expect(page).not_to have_button("Scores")
      expect(page).not_to have_css("div.content div#scores")
    end
  end

  context "Mentor dashboard" do
    let(:user) { FactoryGirl.create(:mentor) }
    let(:sub) { FactoryGirl.create(:submission, :complete) }
    let(:path) { mentor_dashboard_path }

    before do
      TeamRosterManaging.add(sub.team, user)

      sign_in(user)
    end

    scenario "display scores on" do
      SeasonToggles.display_scores="on"
      visit path

      expect(page).to have_button("Scores")
      expect(page).to have_css("div.content div#scores")
    end

    scenario "display scores off" do
      SeasonToggles.display_scores="off"
      visit path

      expect(page).not_to have_button("Scores")
      expect(page).not_to have_css("div.content div#scores")
    end
  end
end