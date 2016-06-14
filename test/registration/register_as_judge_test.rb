require "rails_helper"

class RegisterAsJudgeTest < Capybara::Rails::TestCase
  def test_register
    ScoreCategory.create(name: "Ideation")
    ScoreCategory.create(name: "Technology")

    visit signup_path

    fill_in 'Email', with: "judge@judging.com"
    fill_in 'Password', with: "secret1234"
    fill_in 'Confirm password', with: "secret1234"
    check "Ideation"

    click_button "Sign up"

    assert Authentication.last.email == "judge@judging.com"
    assert UserRole.last.role.judge?
    assert UserRole.last.expertises.flat_map(&:name) == ["Ideation"]
  end
end
