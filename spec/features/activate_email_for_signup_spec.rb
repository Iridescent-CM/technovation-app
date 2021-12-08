require "rails_helper"

RSpec.xfeature "Activate your email to sign up" do
  before { SeasonToggles.enable_signups! }

  scenario "Activate your email for signing up" do
    signup_attempt = SignupAttempt.create!(
      email: "joe@joesak.com",
      password: "secret1234"
    )

    ActionMailer::Base.deliveries.clear

    visit new_signup_attempt_confirmation_path(
      token: signup_attempt.activation_token
    )

    expect(signup_attempt.reload).to be_active
    expect(ActionMailer::Base.deliveries).to be_empty

    expect(current_path).to eq(signup_path)
    expect(page).to have_content(
      "Thank you! Your email is confirmed and you are ready to sign up!"
    )
  end

  scenario "Register the signup attempt on sign up" do
    signup_attempt = SignupAttempt.create!(
      email: "joe@joesak.com",
      password: "secret1234"
    )

    visit new_signup_attempt_confirmation_path(
      token: signup_attempt.activation_token
    )

    click_link I18n.t("views.signups.new.signup_link.student")

    fill_in "First name", with: "Student"
    fill_in "Last name", with: "Test"

    select_date Date.today - 15.years, from: "Date of birth"

    fill_in "School name", with: "John Hughes High."

    click_button "Create Your Account"

    expect(signup_attempt.reload).to be_registered
    expect(signup_attempt.account.email).to eq("joe@joesak.com")
  end
end
