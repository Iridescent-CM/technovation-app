require "rails_helper"

class EditAuthenticationTest < Capybara::Rails::TestCase
  def setup
    auth = CreateAuthentication.(auth_attributes)

    sign_in(auth)
    click_link 'My Account'
    click_link 'Edit'
  end

  def test_edit_login_info
    fill_in 'Email', with: "something@new.com"
    fill_in 'Existing password', with: auth_attributes.fetch(:password)
    fill_in 'New password', with: "someNewSecret123"
    fill_in 'Confirm new password', with: "someNewSecret123"
    click_button 'Save'

    click_link 'Logout'

    auth = Authentication.last

    assert_equal 'something@new.com', auth.email

    auth.password = "someNewSecret123"
    sign_in(auth)

    assert page.has_link?("Logout")
  end

  def test_edit_login_info_requires_correct_existing_password
    fill_in 'Email', with: "something@new.com"
    fill_in 'Existing password', with: "definitely wrong"

    click_button 'Save'

    within(".authentication_existing_password") do
      assert page.has_content?("is invalid")
    end
  end
end
