require "rails_helper"

class RegisterAsJudgeTest < Capybara::Rails::TestCase
  def test_register
    ScoreCategory.create(name: "Ideation", is_expertise: true)
    ScoreCategory.create(name: "Technology", is_expertise: true)

    visit signup_path

    fill_in 'Email', with: "judge@judging.com"
    fill_in 'Password', with: "secret1234"
    fill_in 'Confirm password', with: "secret1234"

    check "Ideation"
    fill_in "Company name", with: "ACME, Inc."
    fill_in "Job title", with: "Engineer in Coyote Physics"

    click_button "Sign up"

    assert JudgeProfile.count == 1
    auth = Authentication.last
    assert auth.email == "judge@judging.com"
    assert auth.profile_expertises.flat_map(&:name) == ["Ideation"]
  end
end
