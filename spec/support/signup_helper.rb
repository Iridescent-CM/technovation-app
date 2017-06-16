module SignupHelper
  def set_signup_token(email)
    token = FactoryGirl.create(:signup_attempt, email: email).signup_token
    page.driver.browser.set_cookie("signup_token=#{token}")
  end
end
