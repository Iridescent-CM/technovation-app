module ControllerSigninHelper
  def sign_in(profile, *factory_opts)
    signin = case profile
             when Symbol
               FactoryBot.create(profile, *factory_opts)
             else
               profile
             end

    controller.set_cookie(:auth_token, signin.account.auth_token)
  end
end
