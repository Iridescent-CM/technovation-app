module ControllerSigninHelper
  def sign_in(profile, *factory_opts)
    signin = case profile
    when Symbol, String
      FactoryBot.create(profile, *factory_opts)
    else
      profile
    end

    controller.set_cookie(CookieNames::AUTH_TOKEN, signin.account.auth_token)
  end
end
