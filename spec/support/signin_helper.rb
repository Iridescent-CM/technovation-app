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

    within "#new_account" do
      fill_in "Email", with: signin.email
      fill_in "Password", with: signin.account.password || "secret1234"

      click_button "Sign in"
    end

    expect(page).to have_content("Welcome back!", wait: 10)
  end

  def sign_out
    visit signout_path

    expect(page).to have_content("See you next time!")
  end
end
