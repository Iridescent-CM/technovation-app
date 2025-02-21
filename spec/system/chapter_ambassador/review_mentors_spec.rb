require "rails_helper"

RSpec.describe "chapter ambassadors reviewing mentors" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

  describe "training completion status" do
    it "displays on their debugging page" do
      untrained_mentor = FactoryBot.create(:mentor, :onboarding, :not_assigned_to_chapter)
      trained_mentor = FactoryBot.create(:mentor, :onboarded, :not_assigned_to_chapter)

      untrained_mentor.chapterable_assignments.create(
        chapterable: chapter_ambassador.current_chapter,
        account: untrained_mentor.account,
        season: Season.current.year,
        primary: true
      )
      trained_mentor.chapterable_assignments.create(
        chapterable: chapter_ambassador.current_chapter,
        account: trained_mentor.account,
        season: Season.current.year,
        primary: true
      )

      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Participants"

      within("#account_#{untrained_mentor.account_id}") do
        click_link "view"
      end

      expect(page).to have_css(".mentor-training", text: "Incomplete")

      click_link "Participants"

      within("#account_#{trained_mentor.account_id}") do
        click_link "view"
      end

      expect(page).to have_css(".mentor-training", text: "Complete")
    end

    it "displays not required for mentors who signed up before the training date" do
      mentor = FactoryBot.create(:mentor, :onboarding, :not_assigned_to_chapter)
      mentor.account.update(
        season_registered_at: ImportantDates.mentor_training_required_since - 1.day
      )
      mentor.chapterable_assignments.create(
        chapterable: chapter_ambassador.current_chapter,
        account: mentor.account,
        season: Season.current.year,
        primary: true
      )

      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Participants"

      within("#account_#{mentor.account_id}") do
        click_link "view"
      end

      expect(page).to have_css(".mentor-training", text: "Not required")
    end
  end
end
