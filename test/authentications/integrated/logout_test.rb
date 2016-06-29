require "rails_helper"

class LogoutTest < Capybara::Rails::TestCase
  def test_logout
    account = CreateAccount.(account_attributes)
    sign_in(account)
    click_link 'Logout'
    refute FindAuthenticationRole.authenticated?({ })
  end
end
