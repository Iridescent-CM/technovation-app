require "rails_helper"

RSpec.feature "Activate your email to sign up" do
  scenario "Use an email that exists" do
    FactoryGirl.create(:judge, email: "joe@joesak.com")
    visit root_path

    fill_in "Email address", with: "joe@joesak.com"
    click_button "Get started"

    expect(page).to have_content("That email is already being used on Technovation.")
    expect(page).to have_link("sign in")
    expect(page).to have_link("reset your password")
  end

  scenario "Use an email that is awaiting activation" do
    signup_attempt = SignupAttempt.create!(email: "joe@joesak.com")
    visit root_path

    fill_in "Email address", with: "joe@joesak.com"
    click_button "Get started"

    expect(current_path).to eq(signup_attempt_path(signup_attempt))
    expect(page).to have_content("Check your spam folder")
    expect(find_field("Email address").value).to eq("joe@joesak.com")
  end

  scenario "Use an email that has already activated" do
    signup_attempt = SignupAttempt.create!(email: "joe@joesak.com")
    signup_attempt.active!

    visit root_path
    fill_in "Email address", with: "joe@joesak.com"
    click_button "Get started"

    expect(current_path).to eq(signup_attempt_path(signup_attempt))
    expect(page).to have_content("You have already confirmed your email!")
    expect(page).to have_link("Continue signing up")
    expect(page).to have_link("sign in")
    expect(page).to have_link("reset your password")
  end

  scenario "Use a new email" do
    visit root_path

    fill_in "Email address", with: "joe@joesak.com"
    click_button "Get started"

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present, "no confirmation email sent"
    expect(mail.to).to eq(["joe@joesak.com"])
    expect(mail.body.parts.last).to have_link(new_signup_attempt_confirmation_url(token: SignupAttempt.last.activation_token))
  end

  scenario "Activate your email for signing up" do
    signup_attempt = SignupAttempt.create!(email: "joe@joesak.com")

    visit new_signup_attempt_confirmation_path(token: signup_attempt.activation_token)

    expect(current_path).to eq(signup_path)
    expect(page).to have_content("Thank you! Your email is confirmed and you are ready to sign up!")

    click_link "Student sign up"

    expect(page).to have_xpath("//input[@value='joe@joesak.com'][@disabled='disabled']")
  end
end
