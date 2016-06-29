require "rails_helper"

class EditAccountTest < Capybara::Rails::TestCase
  def setup
    account = CreateAccount.(account_attributes)

    sign_in(account)
    click_link 'My Account'
    click_link 'Edit'
  end

  def test_edit_login_info
    fill_in 'Email', with: "something@new.com"
    fill_in 'Existing password', with: account_attributes.fetch(:password)
    fill_in 'New password', with: "someNewSecret123"
    fill_in 'Confirm new password', with: "someNewSecret123"
    click_button 'Save'

    click_link 'Logout'

    account = Account.last

    assert_equal 'something@new.com', account.email

    account.password = "someNewSecret123"
    sign_in(account)

    assert page.has_link?("Logout")
  end

  def test_edit_email_requires_correct_existing_password
    fill_in 'Email', with: "something@new.com"
    fill_in 'Existing password', with: "definitely wrong"

    click_button 'Save'

    within(".account_existing_password") do
      assert page.has_content?(
        translated_error(:account, :existing_password, :invalid)
      )
    end
  end

  def test_edit_password_requires_correct_existing_password
    fill_in 'Existing password', with: "definitely wrong"
    fill_in 'New password', with: "somethingNew"

    click_button 'Save'

    within(".account_existing_password") do
      assert page.has_content?(
        translated_error(:account, :existing_password, :invalid)
      )
    end

    within(".account_password_confirmation") do
      assert page.has_content?(
        I18n.translate('errors.messages.confirmation', attribute: :Password)
      )
    end
  end
end
