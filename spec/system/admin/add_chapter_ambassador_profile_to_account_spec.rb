require "rails_helper"

RSpec.describe "Admin add chapter ambassador profile to an account" do
  context "when a chapter ambassador profile can be added to an account with a mentor profile" do
    it "shows a working add chapter ambassador profile button" do
      mentor = FactoryBot.create(:mentor)
      account = mentor.account

      sign_in(:admin)
      visit admin_participant_path(mentor.account)

      click_link "Add Chapter Ambassador profile"

      account.reload

      expect(account.chapter_ambassador_profile).to be_present
    end
  end

  context "when a chapter ambassador profile cannot be added to an account" do
    it "does not show an add chapter ambassador profile button" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador)

      sign_in(:admin)
      visit admin_participant_path(chapter_ambassador.account)

      expect(page).to_not have_link("Add Chapter Ambassador account")
    end
  end

  context "when a chapter ambassador views the mentor debugging section of a mentor profile" do
    it "does not show an add chapter ambassador profile button" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, intro_summary: "Here is my intro summary!")
      mentor = FactoryBot.create(:mentor, :not_assigned_to_chapter)

      mentor.chapterable_assignments.create(
        chapterable: chapter_ambassador.current_chapter,
        account: mentor.account,
        season: Season.current.year,
        primary: true
      )

      sign_in(chapter_ambassador)
      visit chapter_ambassador_participant_path(mentor.account)

      expect(page).to_not have_link("Add Chapter Ambassador account")
    end
  end
end
