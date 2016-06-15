require "rails_helper"

class LogoutTest < Capybara::Rails::TestCase
  def test_logout
    auth = CreateAuthentication.(auth_attributes)
    sign_in(auth)
    click_link 'Logout'
    refute Authentication.authenticated?({ })
  end
end
