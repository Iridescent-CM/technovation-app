require "rails_helper"

RSpec.describe "Admin convert students to mentors" do
  context "when the student is under 14" do
    it "does not show the convert button" do
      FactoryBot.create(:student, date_of_birth: 13.years.ago)

      sign_in(:admin)
      click_link "Participants"
      click_link "view"

      expect(page).not_to have_link("Convert to a mentor")
    end
  end

  context "when the student is 14 and older" do
    it "shows the convert button" do
      student = FactoryBot.create(:student, date_of_birth: 14.years.ago)

      sign_in(:admin)
      click_link "Participants"
      click_link "view"

      expect(page).to have_link(
        "Convert to a mentor",
        href: admin_student_conversions_path(student_profile_id: student.id)
      )
    end
  end
end