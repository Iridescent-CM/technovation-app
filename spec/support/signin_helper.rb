module SigninHelper
  def sign_in(profile)
    visit signin_path
    fill_in 'Email', with: profile.email
    fill_in 'Password', with: profile.account.password || "secret1234"
    click_button 'Sign in'
  end

  def sign_out
    click_link "Logout"
  end
end
