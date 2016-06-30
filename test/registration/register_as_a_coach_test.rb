require "rails_helper"

class RegisterAsACoachTest < Capybara::Rails::TestCase
  def test_signup_as_coach
    Expertise.create!(name: "Science")
    Expertise.create!(name: "Technology")

    visit signup_path

    fill_in "Email", with: "coach@coaching.com"
    fill_in "Password", with: "coach@coaching.com"
    fill_in "Confirm password", with: "coach@coaching.com"

    fill_in "First name", with: "Coachy"
    fill_in "Last name", with: "McGee"

    select "United States", from: "Country"
    fill_in "State / Province", with: "Illinois"
    fill_in "City", with: "Chicago"

    select_date Date.today - 25.years, from: "Date of birth"

    within('.coach-field') do
      check "Science"
      fill_in "School or company name", with: "ACME, Inc."
      fill_in "Job title", with: "Engineer in Coyote Physics"
    end

    click_button "Sign up"

    assert CoachProfile.count == 1
    coach = CoachAccount.last
    assert coach.school_company_name == "ACME, Inc."
    assert coach.job_title == "Engineer in Coyote Physics"
    assert coach.expertises.flat_map(&:name) == ["Science"]
  end
end
