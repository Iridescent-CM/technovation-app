require "rails_helper"

class AuthenticateJudgeTest < Capybara::Rails::TestCase
  def test_judge_scores_restricts_guests
    visit judge_scores_path
    assert page.current_path == signin_path
  end

  def test_judge_scores_restricts_non_judges
    auth = CreateAuthentication.(auth_attributes) # Given role no_role by default
    sign_in(auth)
    visit judge_scores_path
    assert page.current_path == signin_path
  end

  def test_judge_scores_allows_admins
    admin = CreateAdmin.(auth_attributes)
    sign_in(admin)
    visit judge_scores_path
    assert page.current_path == judge_scores_path
  end

  def test_judge_scores_allows_judges
    judge = CreateJudge.(auth_attributes)
    sign_in(judge)
    visit judge_scores_path
    assert page.current_path == judge_scores_path
  end
end
