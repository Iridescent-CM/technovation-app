require "rails_helper"

class RegisterAsAStudentTest < Capybara::Rails::TestCase
  def test_signup_as_student
    visit signup_path
    choose 'Student'

    fill_in "Email", with: "student@school.com"
    fill_in "Password", with: "student@school.com"
    fill_in "Confirm password", with: "student@school.com"

    #fill_in "Date of Birth", with: Date.today - 15.years
    fill_in "Parent or guardian email", with: "parent@guardian.com"

    click_button "Sign up"

    assert Authentication.last.roles.last.student?
    assert Authentication.last.profile.date_of_birth == Date.today - 15.years
    assert Authentication.last.profile.parent_guardian_email == "parent@guardian.com"
  end
end
