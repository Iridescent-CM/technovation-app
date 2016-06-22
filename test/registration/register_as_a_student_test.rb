require "rails_helper"

class RegisterAsAStudentTest < Capybara::Rails::TestCase
  def test_signup_as_student
    visit signup_path
    choose 'Student'

    fill_in "Email", with: "student@school.com"
    fill_in "Password", with: "student@school.com"
    fill_in "Confirm password", with: "student@school.com"

    fill_in "First name", with: "Study"
    fill_in "Last name", with: "McGee"
    fill_in "City", with: "Chicago"
    fill_in "Region", with: "IL"
    fill_in "Country", with: "USA"
    select_date Date.today - 15.years, from: "Date of birth"

    fill_in "School name", with: "Schooly McSchool"
    fill_in "Parent guardian name", with: "Parenty McGee"
    fill_in "Parent or guardian email", with: "parent@guardian.com"

    click_button "Sign up"

    assert StudentProfile.count == 1
    assert BasicProfile.count == 1
    assert StudentProfile.last.parent_guardian_email == "parent@guardian.com"
    assert BasicProfile.last.date_of_birth == Date.today - 15.years
  end
end
