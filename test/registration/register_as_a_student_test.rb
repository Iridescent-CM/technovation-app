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
    auth = Authentication.last
    assert auth.profile_parent_guardian_email == "parent@guardian.com"
    assert auth.profile_parent_guardian_name == "Parenty McGee"
    assert auth.profile_school_name == "Schooly McSchool"
  end
end
