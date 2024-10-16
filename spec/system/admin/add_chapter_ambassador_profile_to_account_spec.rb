require "rails_helper"

RSpec.describe "Admin add chapter ambassador profile to an account" do
  context "when a chapter ambassador profile can be added to an account with a mentor profile" do
    it "shows a working add chapter ambassador profile button" do
      mentor_profile = FactoryBot.create(:mentor)
      account = mentor_profile.account

      sign_in(:admin)
      click_link "Participants"
      click_link "view"

      click_link "Add Chapter Ambassador profile"

      account.reload

      expect(account.chapter_ambassador_profile).to be_present
    end
  end

  context "when a chapter ambassador profile cannot be added to an account" do
    it "does not show an add chapter ambassador profile button" do
      FactoryBot.create(:chapter_ambassador)

      sign_in(:admin)
      click_link "Participants"
      click_link "view"

      expect(page).to_not have_link("Add Chapter Ambassador account")
    end
  end

  context "when a chapter ambassador views the mentor debugging section of a mentor profile" do
    it "does not show an add chapter ambassador profile button" do
      mentor = FactoryBot.create(:mentor)
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved, intro_summary: "Here is my intro summary!")

      sign_in(chapter_ambassador)
      click_link "Chapter Admin Activity"
      click_link "Participants"

      visit chapter_ambassador_participant_path(mentor.account)

      expect(page).to_not have_link("Add Chapter Ambassador account")
    end
  end
end
