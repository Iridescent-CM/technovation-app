require "rails_helper"

RSpec.describe "Mentor selecting a chapter", :js do
  let(:mentor) { FactoryBot.create(:mentor, :chicago, :not_assigned_to_chapter) }

  context "when there is a chapter in the same area" do
    let!(:chapter) { FactoryBot.create(:chapter, :chicago) }

    it "assigns the chapter to the mentor after they choose it" do
      sign_in(mentor)

      choose chapter.name
      click_button "Save"

      expect(mentor.account.current_chapter).to eq(chapter)
    end

    it "sets 'force_chapterable_selection' to false after they choose a chapter" do
      sign_in(mentor)

      choose chapter.name
      click_button "Save"

      mentor.reload
      expect(mentor.account.force_chapterable_selection?).to eq(false)
    end

    it "updates the account to 'no_chapterable_selected' when they choose the 'None of the Above' option" do
      sign_in(mentor)

      choose "None of the Above"
      click_button "Save"

      mentor.reload
      expect(mentor.account.no_chapterable_selected?).to eq(true)
    end

    it "sets 'force_chapterable_selection' to false when they choose the 'None of the Above' option" do
      sign_in(mentor)

      choose "None of the Above"
      click_button "Save"

      mentor.reload
      expect(mentor.account.force_chapterable_selection?).to eq(false)
    end

    it "updates mentor profile fields when they select team matching options" do
      sign_in(mentor)

      choose "None of the Above"
      check "Allow teams to find you in search results and invite you to join"
      check "Indicate to teams that you can be an online, remote mentor"
      click_button "Save"

      mentor.reload
      expect(mentor.virtual?).to eq(true)
      expect(mentor.accepting_team_invites?).to eq(true)
    end
  end

  context "when there are no chapters or clubs in the same area" do
    Chapter.destroy_all
    Club.destroy_all

    it "updates the account to 'no_chapterables_available' after they click 'Acknowledge and Go to Dashboard'" do
      sign_in(mentor)

      expect(page).to have_content("Unfortunately, there are no Chapters or Clubs currently active in your country")
      click_button "Acknowledge and Go To Dashboard"

      mentor.reload
      expect(mentor.account.no_chapterables_available?).to eq(true)
    end

    it "sets 'force_chapterable_selection' to false after they click 'Acknowledge and Go to Dashboard'" do
      sign_in(mentor)

      expect(page).to have_content("Unfortunately, there are no Chapters or Clubs currently active in your country")
      click_button "Acknowledge and Go To Dashboard"

      mentor.reload
      expect(mentor.account.force_chapterable_selection?).to eq(false)
    end
  end
end
