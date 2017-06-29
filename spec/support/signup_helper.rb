module SignupHelper
  def set_signup_token(email)
    token = FactoryGirl.create(:signup_attempt, email: email).signup_token
    page.driver.browser.set_cookie("signup_token=#{token}")
  end

  def set_signup_and_permission_token(email)
    attempt = FactoryGirl.create(:signup_attempt, email: email)
    page.driver.browser.set_cookie("signup_token=#{attempt.signup_token}")
    page.driver.browser.set_cookie("admin_permission_token=#{attempt.admin_permission_token}")
  end
end
