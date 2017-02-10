require "rails_helper"

RSpec.feature "Activate your email to sign up" do
  scenario "input doesn't look like an email" do
    visit root_path

    fill_in "Email address", with: "joejoesak.com"
    click_button "Get Started"

    expect(page).to have_content("doesn't appear to be an email address")

    fill_in "Email address", with: "joe@joesak.com."
    click_button "Get Started"

    expect(page).to have_content("doesn't appear to be an email address")
  end

  scenario "Use an email that exists" do
    ActionMailer::Base.deliveries.clear

    FactoryGirl.create(:judge, email: "joe@joesak.com")
    visit root_path

    fill_in "Email address", with: "joe@joesak.com"
    fill_in "Create a password", with: "secret1234"
    click_button "Get Started"

    expect(ActionMailer::Base.deliveries).to be_empty
    expect(current_path).to eq(judge_dashboard_path)
  end

  scenario "Use an email that is awaiting activation" do
    signup_attempt = SignupAttempt.create!(email: "joe@joesak.com", password: "secret1234")
    visit root_path

    fill_in "Email address", with: "joe@joesak.com"
    fill_in "Create a password", with: "secret1234"
    click_button "Get Started"

    expect(current_path).to eq(signup_attempt_path(signup_attempt.pending_token))
    expect(page).to have_content("Check your spam folder")
    expect(find_field("Email address").value).to eq("joe@joesak.com")
  end

  scenario "Use an email that has already activated" do
    signup_attempt = SignupAttempt.create!(email: "joe@joesak.com", password: "secret1234")
    signup_attempt.active!

    ActionMailer::Base.deliveries.clear

    visit root_path
    fill_in "Email address", with: "joe@joesak.com"
    fill_in "Create a password", with: "secret1234"
    click_button "Get Started"

    expect(ActionMailer::Base.deliveries).to be_empty
    expect(current_path).to eq(signup_attempt_path(signup_attempt.pending_token))
    expect(page).to have_content("You have already confirmed your email!")
    expect(page).to have_link("Continue signing up")
  end

  scenario "Use a new email" do
    visit root_path

    fill_in "Email address", with: "joe@joesak.com"
    fill_in "Create a password", with: "secret1234"
    click_button "Get Started"

    mail = ActionMailer::Base.deliveries.last
    expect(mail).to be_present, "no confirmation email sent"
    expect(mail.to).to eq(["joe@joesak.com"])
    expect(mail.body).to have_link("Confirm Email Address", href: new_signup_attempt_confirmation_url(token: SignupAttempt.last.activation_token))
  end

  scenario "Activate your email for signing up" do
    signup_attempt = SignupAttempt.create!(email: "joe@joesak.com", password: "secret1234")
    ActionMailer::Base.deliveries.clear

    visit new_signup_attempt_confirmation_path(token: signup_attempt.activation_token)
    expect(signup_attempt.reload).to be_active
    expect(ActionMailer::Base.deliveries).to be_empty

    expect(current_path).to eq(signup_path)
    expect(page).to have_content("Thank you! Your email is confirmed and you are ready to sign up!")
  end

  scenario "Register the signup attempt on sign up" do
    signup_attempt = SignupAttempt.create!(email: "joe@joesak.com", password: "secret1234")

    visit new_signup_attempt_confirmation_path(token: signup_attempt.activation_token)

    click_link "Student sign up"

    fill_in "First name", with: "Student"
    fill_in "Last name", with: "Test"

    select_date Date.today - 15.years, from: "Date of birth"

    fill_in "School name", with: "John Hughes High."

    click_button "Create Your Account"

    expect(signup_attempt.reload).to be_registered
    expect(signup_attempt.account.email).to eq("joe@joesak.com")
  end

  scenario "Register after team invite" do
    team = FactoryGirl.create(:team)
    email = "Student@test.com"

    team.team_member_invites.create!(
      inviter: team.students.first,
      invitee_email: email,
    )

    visit student_signup_path(
      token: SignupAttempt.find_by(email: email).activation_token
    )

    click_button "Create Your Account"

    within(".student_profile_account_password") {
      expect(page).to have_css('.error', text: "can't be blank")
    }
  end
end
