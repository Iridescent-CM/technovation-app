module ControllerSignupHelper
  def set_signup_token(attrs = {})
    controller.set_cookie(
      CookieNames::SIGNUP_TOKEN,
      FactoryBot.create(:signup_attempt, attrs).signup_token
    )
  end
end
