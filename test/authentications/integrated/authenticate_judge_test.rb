require "rails_helper"

class AuthenticateJudgeTest < Capybara::Rails::TestCase
  def test_judge_scores_restricts_guests
    visit judge_scores_path
    assert page.current_path == signin_path
  end

  def test_judge_scores_restricts_non_judges
    account = CreateAccount.(account_attributes)
    sign_in(account)
    visit judge_scores_path
    assert page.current_path == signin_path
  end

  def test_judge_scores_allows_admins
    admin = CreateAdmin.(account_attributes)
    sign_in(admin)
    visit judge_scores_path
    assert page.current_path == judge_scores_path
  end

  def test_judge_scores_allows_judges
    judge = CreateAccount.(judge_attributes)
    sign_in(judge)
    visit judge_scores_path
    assert page.current_path == judge_scores_path
  end
end
