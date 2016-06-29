require 'rails_helper'

class AddScoringDataTest < Capybara::Rails::TestCase
  def test_guests_restricted
    visit new_admin_score_category_path
    assert page.current_path == signin_path
  end

  def test_non_admins_restricted
    judge = CreateAccount.(account_attributes)
    sign_in(judge)
    visit new_admin_score_category_path
    assert page.current_path == signin_path
  end

  def test_admins_allowed
    admin = CreateAdmin.(account_attributes)
    sign_in(admin)
    visit new_admin_score_category_path
    assert page.current_path == new_admin_score_category_path
  end
end
