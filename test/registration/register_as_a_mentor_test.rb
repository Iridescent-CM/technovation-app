require "rails_helper"

class RegisterAsAMentorTest < Capybara::Rails::TestCase
  def test_signup_as_mentor
    Expertise.create!(name: "Science")
    Expertise.create!(name: "Technology")

    visit mentor_signup_path

    fill_in "Email", with: "mentor@mentoring.com"
    fill_in "Password", with: "mentor@mentoring.com"
    fill_in "Confirm password", with: "mentor@mentoring.com"

    fill_in "First name", with: "Mentory"
    fill_in "Last name", with: "McGee"

    select "United States", from: "Country"
    fill_in "State / Province", with: "Illinois"
    fill_in "City", with: "Chicago"

    select_date Date.today - 25.years, from: "Date of birth"

    within('.mentor-field') do
      check "Science"
      fill_in "School or company name", with: "ACME, Inc."
      fill_in "Job title", with: "Engineer in Coyote Physics"
    end

    click_button "Sign up"

    assert MentorProfile.count == 1
    mentor = MentorAccount.last
    assert mentor.school_company_name == "ACME, Inc."
    assert mentor.job_title == "Engineer in Coyote Physics"
    assert mentor.expertises.flat_map(&:name) == ["Science"]
  end
end
