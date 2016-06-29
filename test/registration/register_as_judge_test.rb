require "rails_helper"

class RegisterAsJudgeTest < Capybara::Rails::TestCase
  def test_register
    ScoreCategory.create(name: "Ideation", is_expertise: true)
    ScoreCategory.create(name: "Technology", is_expertise: true)

    visit signup_path

    fill_in 'Email', with: "judge@judging.com"
    fill_in 'Password', with: "secret1234"
    fill_in 'Confirm password', with: "secret1234"

    fill_in "First name", with: "Judgey"
    fill_in "Last name", with: "McGee"

    select "United States", from: "Country"
    fill_in "State / Province", with: "Illinois"
    fill_in "City", with: "Chicago"

    select_date Date.today - 25.years, from: "Date of birth"

    within('.judge-field') do
      check "Ideation"
      fill_in "Company name", with: "ACME, Inc."
      fill_in "Job title", with: "Engineer in Coyote Physics"
    end

    click_button "Sign up"

    assert JudgeProfile.count == 1
    account = Account.last
    assert account.email == "judge@judging.com"
    assert account.profile_scoring_expertises.flat_map(&:name) == ["Ideation"]
  end
end
