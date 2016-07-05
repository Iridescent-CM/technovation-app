require "rails_helper"

class LogoutTest < Capybara::Rails::TestCase
  def test_logout
    account = JudgeAccount.create(judge_attributes)
    sign_in(account)
    click_link 'Logout'
    visit judge_dashboard_path
    assert current_path == signin_path
  end
end
