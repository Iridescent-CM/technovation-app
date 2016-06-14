require "rails_helper"

class AuthenticateJudgeTest < Capybara::Rails::TestCase
  def test_judges_scores_restricts_guests
    visit judges_scores_path
    assert page.current_path == signin_path
  end

  def test_judges_scores_allows_judges
    judge = CreateJudge.(email: "judge@judging.com",
                         password: "secret123",
                         password_confirmation: "secret123")
    sign_in(judge)

    visit judges_scores_path
    assert page.current_path == judges_scores_path
  end
end
