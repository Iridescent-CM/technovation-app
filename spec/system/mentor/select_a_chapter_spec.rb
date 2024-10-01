require "rails_helper"

RSpec.describe "Mentor selecting a chapter", :js do
  let(:mentor) { FactoryBot.create(:mentor, :chicago, :not_assigned_to_chapter) }

  context "when there is a chapter in the same area" do
    let!(:chapter) { FactoryBot.create(:chapter, :chicago) }

    it "it assigns the chapter to the mentor after they choose it" do
      sign_in(mentor)

      choose chapter.name
      click_button "Save"

      expect(mentor.account.current_chapter).to eq(chapter)
    end

    it "it updates the account to 'no_chapter_selected' when they choose the 'I'm not sure' option" do
      sign_in(mentor)

      choose "I'm not sure"
      click_button "Save"

      mentor.reload
      expect(mentor.account.no_chapter_selected?).to eq(true)
    end
  end

  context "when there are no chapters in the same area" do
    Chapter.destroy_all

    it "it updates the account to 'no_chapter_selected' after they click 'Acknowledge and Go to Dashboard'" do
      sign_in(mentor)

      expect(page).to have_content("Unfortunately, there are no chapters currently active in your country")
      click_button "Acknowledge and Go To Dashboard"

      mentor.reload
      expect(mentor.account.no_chapter_selected?).to eq(true)
    end
  end
end
