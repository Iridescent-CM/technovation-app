module SigninHelper
  # Capybara fill_in does not always fire `input`, so under JS drivers Stimulus
  # may leave Sign In disabled. Dispatch the event so the button can enable.
  # Under rack_test, Stimulus does not run and the button stays enabled.
  def fill_in_signin_password(password)
    fill_in "Password", with: password

    page.execute_script(<<~JS)
      const field = document.querySelector('[data-signin-form-target="password"]');
      if (field) {
        field.dispatchEvent(new Event("input", { bubbles: true }));
      }
    JS
  rescue Capybara::NotSupportedByDriverError
    nil
  end

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
      fill_in_signin_password(signin.account.password || PasswordHelpers::VALID_PASSWORD)

      click_button "Sign in"
    end

    expect(page).to have_content("Welcome back!")
  end

  def sign_out
    visit signout_path

    expect(page).to have_current_path("/login")
    expect(page).to have_content("See you next time!")
  end
end
