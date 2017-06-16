module ControllerSignupHelper
  def set_signup_token(attrs = {})
    controller.set_cookie(
      :signup_token,
      FactoryGirl.create(:signup_attempt, attrs).signup_token
    )
  end
end
