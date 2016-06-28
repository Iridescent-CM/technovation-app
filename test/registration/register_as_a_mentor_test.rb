require "rails_helper"

class RegisterAsAMentorTest < Capybara::Rails::TestCase
  def test_signup_as_mentor
    Expertise.create!(name: "Science")
    Expertise.create!(name: "Technology")

    visit signup_path

    fill_in "Email", with: "mentor@mentoring.com"
    fill_in "Password", with: "mentor@mentoring.com"
    fill_in "Confirm password", with: "mentor@mentoring.com"

    within('.mentor-field') do
      check "Science"
      fill_in "School or company name", with: "ACME, Inc."
      fill_in "Job title", with: "Engineer in Coyote Physics"
    end

    click_button "Sign up"

    assert MentorProfile.count == 1
    auth = Authentication.last
    assert auth.profile_school_company_name == "ACME, Inc."
    assert auth.profile_job_title == "Engineer in Coyote Physics"
    assert auth.profile_expertises.flat_map(&:name) == ["Science"]
  end
end
