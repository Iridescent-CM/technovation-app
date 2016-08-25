module SigninHelper
  def sign_in(account)
    visit signin_path
    fill_in 'Email', with: account.email
    fill_in 'Password', with: account.password || "secret1234"
    click_button 'Sign in'
  end

  def sign_out
    click_link "Logout"
  end
end
