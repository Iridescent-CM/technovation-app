require "rails_helper"

class RegisterAsJudgeTest < Capybara::Rails::TestCase
  def test_register
    ScoreCategory.create(name: "Ideation")
    ScoreCategory.create(name: "Technology")

    visit signup_path
    choose 'Judge'

    fill_in 'Email', with: "judge@judging.com"
    fill_in 'Password', with: "secret1234"
    fill_in 'Confirm password', with: "secret1234"
    check "Ideation"

    click_button "Sign up"

    assert Authentication.last.email == "judge@judging.com"
    assert JudgeProfile.count == 1
    assert JudgeProfile.last.expertises.flat_map(&:name) == ["Ideation"]
  end
end
