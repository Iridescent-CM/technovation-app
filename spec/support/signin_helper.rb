module SigninHelper
  def sign_in(profile, *traits)
    signin = case profile
             when Symbol
               FactoryBot.create(profile, *traits)
             else
               profile
             end

    visit signin_path

    fill_in 'Email', with: signin.email
    fill_in 'Password', with: signin.account.password || "secret1234"

    click_button 'Sign in'
  end

  def sign_out
    click_link "Logout"
  end
end
