require "rails_helper"

class RegisterAsACoachTest < Capybara::Rails::TestCase
  def test_signup_as_coach
    Expertise.create!(name: "Science")
    Expertise.create!(name: "Technology")

    visit signup_path

    fill_in "Email", with: "coach@coaching.com"
    fill_in "Password", with: "coach@coaching.com"
    fill_in "Confirm password", with: "coach@coaching.com"

    within('.coach-field') do
      check "Science"
      fill_in "School or company name", with: "ACME, Inc."
      fill_in "Job title", with: "Engineer in Coyote Physics"
    end

    click_button "Sign up"

    assert CoachProfile.count == 1
    account = Account.last
    assert account.profile_school_company_name == "ACME, Inc."
    assert account.profile_job_title == "Engineer in Coyote Physics"
    assert account.profile_expertises.flat_map(&:name) == ["Science"]
  end
end
