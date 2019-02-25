require "rails_helper"

RSpec.describe "Admins reviewing mentors" do
  describe "training completion status" do
    it "displays on their debugging page" do
      untrained = FactoryBot.create(:mentor, :onboarding)
      trained = FactoryBot.create(:mentor, :onboarded)

      sign_in(:admin)
      click_link "Participants"

      within_results_page_with("#account_#{untrained.account_id}") do
        click_link "view"
      end

      expect(page).to have_css(".mentor-training", text: "Incomplete")

      click_link "Participants"

      within_results_page_with("#account_#{trained.account_id}") do
        click_link "view"
      end

      expect(page).to have_css(".mentor-training", text: "Complete")
    end

    it "displays not required for mentors who signed up before the training date" do
      mentor = FactoryBot.create(:mentor, :onboarding)
      mentor.account.update(
        season_registered_at: ImportantDates.mentor_training_required_since - 1.day
      )

      sign_in(:admin)

      click_link "Participants"

      within_results_page_with("#account_#{mentor.account_id}") do
        click_link "view"
      end

      expect(page).to have_css(".mentor-training", text: "Not required")
    end
  end
end