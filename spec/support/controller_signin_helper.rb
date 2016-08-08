module ControllerSigninHelper
  def sign_in(account)
    controller.set_cookie(:auth_token, account.auth_token)
  end
end
