module ControllerSigninHelper
  def sign_in(profile)
    signin = case profile
             when Symbol
               FactoryBot.create(profile)
             else
               profile
             end

    controller.set_cookie(:auth_token, signin.account.auth_token)
  end
end
