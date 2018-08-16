module RequestSigninHelper
  def sign_in(profile, *factory_opts)
    signin = case profile
             when Symbol, String
               FactoryBot.create(profile, *factory_opts)
             else
               profile
             end

    post "/signins", params: { account: { email: profile.email, password: 'secret1234' } }
  end
end