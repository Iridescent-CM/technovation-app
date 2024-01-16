require "rails_helper"

RSpec.describe "chapter ambassador convert students to mentors" do
  context "when the student is under 18" do
    it "does not show the convert button" do
      student = FactoryBot.create(:student, date_of_birth: 17.years.ago)
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)
      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Participants"
      within("#account_#{student.account_id}") do
        click_link "view"
      end

      expect(page).not_to have_link("Convert to a mentor")
    end
  end

  context "when the student is 18 and older" do
    it "shows the convert button" do
      student = FactoryBot.create(:student, date_of_birth: 18.years.ago)
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)
      sign_in(chapter_ambassador)
      visit(chapter_ambassador_chapter_admin_path)

      click_link "Participants"

      within("#account_#{student.account_id}") do
        click_link "view"
      end

      expect(page).to have_link(
        "Convert to a mentor",
        href: chapter_ambassador_student_conversions_path(student_profile_id: student.id)
      )
    end
  end
end
