require "rails_helper"

class RegisterAsAStudentTest < Capybara::Rails::TestCase
  def setup
    visit signup_path

    fill_in "Email", with: "student@school.com"
    fill_in "Password", with: "student@school.com"
    fill_in "Confirm password", with: "student@school.com"

    fill_in "School name", with: "Schooly McSchool"
    fill_in "Parent or guardian's name", with: "Parenty McGee"
    fill_in "Parent or guardian's email", with: "parent@guardian.com"

    fill_in "First name", with: "Studenty"
    fill_in "Last name", with: "McGee"

    select "United States", from: "Country"
    fill_in "State / Province", with: "Illinois"
    fill_in "City", with: "Chicago"

    select_date Date.today - 15.years, from: "Date of birth"

    click_button "Sign up"
  end

  def test_signup_as_student
    assert StudentProfile.count == 1
    student = StudentAccount.last
    assert student.parent_guardian_email == "parent@guardian.com"
    assert student.parent_guardian_name == "Parenty McGee"
    assert student.school_name == "Schooly McSchool"
  end

  def test_student_must_complete_profile
    visit student_dashboard_path
    assert page.has_link?('Complete the pre-program survey')
    assert page.has_link?('Re-send the parental consent form')

    StudentProfile.last.complete_pre_program_survey!
    StudentProfile.last.sign_parental_consent_form!

    visit student_dashboard_path
    refute page.has_link?('Complete the pre-program survey')
    refute page.has_link?('Re-send the parental consent form')
  end
end
