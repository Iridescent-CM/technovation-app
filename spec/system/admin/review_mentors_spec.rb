require "rails_helper"

RSpec.describe "Admins reviewing mentors" do
  describe "training completion status" do
    it "displays on their debugging page" do
      untrained = FactoryBot.create(:mentor, :onboarding)
      trained = FactoryBot.create(:mentor, :onboarded)

      sign_in(:admin)
      click_link "Participants"

      within("#account_#{untrained.account_id}") do
        click_link "view"
      end

      expect(page).to have_css(".mentor-training", text: "Incomplete")

      click_link "Participants"

      within("#account_#{trained.account_id}") do
        click_link "view"
      end

      expect(page).to have_css(".mentor-training", text: "Complete")
    end
  end
end