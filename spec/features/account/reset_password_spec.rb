require "rails_helper"

RSpec.feature "Reset your forgotten password" do
  before do
    scope = %i[mentor student chapter_ambassador].sample

    FactoryBot.create(
      scope,
      account: FactoryBot.create(
        :account,
        email: "find@me.com",
        password: "oldforgotten"
      )
    )

    SeasonToggles.enable_signup(scope)

    visit signin_path

    click_link "Reset your password"
  end

  scenario "Email not found" do
    fill_in "Email", with: "doesnt@exist.com"
    click_button "Send me a password reset link"

    expect(current_path).to eq(password_resets_path)
    expect(page).to have_css(
      ".flash--alert",
      text: "Sorry, but we couldn't find an account with that email address."
    )
  end

  scenario "Email found" do
    fill_in "Email", with: "find@me.com"
    click_button "Send me a password reset link"

    expect(current_path).to eq(signin_path)
    expect(page).to have_css(
      ".flash--success",
      text: "We sent password reset instructions to your email"
    )

    account = Account.last
    email = ActionMailer::Base.deliveries.last
    expect(account.password_reset_token).not_to be_blank
    expect(account.password_reset_token_sent_at).not_to be_blank
    expect(email.to).to eq(["find@me.com"])
    expect(email.subject).to eq("Reset your Technovation password")

    url = "http://#{ENV["HOST_DOMAIN"]}/passwords/new?token=#{account.password_reset_token}"

    expect(email.body.to_s).to include("href=\"#{url}\"")
  end

  scenario "Attempt a password reset too late" do
    account = Account.last
    account.enable_password_reset!

    Timecop.travel(2.hours.from_now + 1.minute) do
      visit new_password_path(token: account.password_reset_token)
      expect(current_path).to eq(new_password_reset_path)
      expect(page).to have_css(
        ".flash--alert",
        text: "That password request token has expired. You should request a new one."
      )
    end
  end

  scenario "Attempt a password reset with a bad token" do
    account = Account.last
    account.enable_password_reset!

    visit new_password_path(token: "bad")
    expect(current_path).to eq(new_password_reset_path)
    expect(page).to have_css(
      ".flash--alert",
      text: "That password request token is invalid. You should request a new one."
    )
  end

  scenario "Attempt a bad password" do
    account = Account.last
    account.enable_password_reset!

    visit new_password_path(token: account.password_reset_token)
    fill_in "Create a password", with: "a"
    fill_in "Confirm password", with: "a"
    click_button "Save"

    expect(current_path).to eq(passwords_path)
    expect(page).to have_css(".error", text: "too short")

    fill_in "Create a password", with: "abcdefghij"
    fill_in "Confirm password", with: "zyxwvutsrqp"
    click_button "Save"

    expect(current_path).to eq(passwords_path)
    expect(page).to have_css(".error", text: "does not match")
  end

  scenario "Reset password successfully" do
    account = Account.last
    account.enable_password_reset!

    visit new_password_path(token: account.password_reset_token)
    fill_in "Create a password", with: "greatnewsecret"
    fill_in "Confirm password", with: "greatnewsecret"
    click_button "Save"

    click_link "Logout"
    visit signin_path

    fill_in "Email", with: account.email
    fill_in "Password", with: "greatnewsecret"
    click_button "Sign in"
    expect(current_path).to eq(
      send("#{account.scope_name.sub(/^\w+_chapter_ambassador/, "chapter_ambassador")}_dashboard_path")
    )
    expect(account.reload.password_reset_token).to be_blank
    expect(account.reload.password_reset_token_sent_at).to be_blank
  end
end
