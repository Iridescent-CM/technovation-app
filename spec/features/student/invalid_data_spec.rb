require "rails_helper"

RSpec.feature "Students with invalid data" do
  scenario "When your parent/guardian email is invalid" do
    student = FactoryGirl.create(:student)
    student.update_column(:parent_guardian_email, "bad-email")

    sign_in(student)

    expect(page).to have_content "Hey, wait a moment! We detected a problem with your profile. Your parent/guardian email appears to be invalid."
    expect(page).to have_link "Update your parent/guardian email address", href: edit_student_profile_path(anchor: "account-profile-details")
  end
end
