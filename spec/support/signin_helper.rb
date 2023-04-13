module SigninHelper
  def sign_in(profile, *traits)
    visit signout_path
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

    expect(page).to have_content("Welcome back!")
  end

  def sign_out
    visit signout_path

    expect(page).to have_content("See you next time!")
  end

  def student_sign_out
    find('#student-dropdown-wrapper').click
    click_link "Logout"

    expect(page).to have_content("See you next time!")
  end
end
