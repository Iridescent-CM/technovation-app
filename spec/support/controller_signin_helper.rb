module ControllerSigninHelper
  def sign_in(profile)
    controller.set_cookie(:auth_token, profile.account.auth_token)
  end
end
