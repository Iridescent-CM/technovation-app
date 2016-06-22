require "rails_helper"

class RegisterAsAStudentTest < Capybara::Rails::TestCase
  def test_signup_as_student
    visit signup_path

    fill_in "Email", with: "student@school.com"
    fill_in "Password", with: "student@school.com"
    fill_in "Confirm password", with: "student@school.com"

    fill_in "School name", with: "Schooly McSchool"
    fill_in "Parent or guardian's name", with: "Parenty McGee"
    fill_in "Parent or guardian's email", with: "parent@guardian.com"

    click_button "Sign up"

    assert StudentProfile.count == 1
    assert StudentProfile.last.parent_guardian_email == "parent@guardian.com"
    assert StudentProfile.last.parent_guardian_name == "Parenty McGee"
    assert StudentProfile.last.school_name == "Schooly McSchool"
  end
end
