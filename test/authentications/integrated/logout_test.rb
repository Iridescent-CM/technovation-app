require "rails_helper"

class LogoutTest < Capybara::Rails::TestCase
  def test_logout
    account = Account.create(account_attributes)
    sign_in(account)
    click_link 'Logout'
    refute FindAccount.authenticated?({ })
  end
end
