module RequestSigninHelper
  def sign_in(profile, *factory_opts)
    signin = case profile
    when Symbol, String
      FactoryBot.create(profile, *factory_opts)
    else
      profile
    end

    post "/signins", params: {account: {email: signin.email, password: "secret1234"}}
  end

  def sign_out
    get "/logout"
  end
end
