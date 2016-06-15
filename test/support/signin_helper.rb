module SigninHelper
  def sign_in(auth)
    visit signin_path
    fill_in 'Email', with: auth.email
    fill_in 'Password', with: auth.password
    click_button 'Sign in'
  end
end
