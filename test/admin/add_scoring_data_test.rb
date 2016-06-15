require 'rails_helper'

class AddScoringDataTest < Capybara::Rails::TestCase
  def test_guests_restricted
    visit new_admin_score_category_path
    assert page.current_path == signin_path
  end

  def test_non_admins_restricted
    judge = CreateJudge.(auth_attributes)
    sign_in(judge)
    visit new_admin_score_category_path
    assert page.current_path == signin_path
  end
end
