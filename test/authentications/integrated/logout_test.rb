require "rails_helper"

class LogoutTest < Capybara::Rails::TestCase
  def test_logout
    auth = CreateAuthentication.(email: "auth@example.com",
                                 password: "secret123",
                                 password_confirmation: "secret123")
    sign_in(auth)

    click_link 'Logout'

    refute Authentication.authenticated?({ })
  end
end
