require "rails_helper"

RSpec.describe "Students selecting a chapter", :js do
  let(:student) { FactoryBot.create(:student, :chicago, :not_assigned_to_chapter) }

  context "when there is a chapter in the same area" do
    let!(:chapter) { FactoryBot.create(:chapter, :chicago) }

    it "it assigns the chapter to the student after they choose it" do
      sign_in(student)

      choose chapter.name
      click_button "Save"

      expect(student.account.current_chapter).to eq(chapter)
    end

    it "it updates the account to 'no_chapter_selected' when they choose the 'None of the Above' option" do
      sign_in(student)

      choose "None of the Above"
      click_button "Save"

      student.reload
      expect(student.account.no_chapter_selected?).to eq(true)
    end
  end

  context "when there are no chapters or clubs in the same area" do
    before do
      Chapter.destroy_all
      Club.destroy_all
    end

    it "it updates the account to 'no_chapter_selected' after they click 'Acknowledge and Go to Dashboard'" do
      sign_in(student)

      expect(page).to have_content("Unfortunately, there are no Chapters currently active in your country")
      click_button "Acknowledge and Go To Dashboard"

      student.reload
      expect(student.account.no_chapter_selected?).to eq(true)
    end
  end
end
