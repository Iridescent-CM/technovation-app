require "rails_helper"

RSpec.feature "Regional Ambassadors registration" do
  before do
    page.driver.browser.set_cookie("signup_token=#{SignupAttempt.create!(email: "regional@ambassador.com", password: "secret1234", status: SignupAttempt.statuses[:active]).signup_token}")

    visit signup_path
    click_link "Apply to become a Regional Ambassador"

    fill_in "First name", with: "Regional"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    fill_in "Postal code -OR- City & State/Province", with: 60647

    fill_in "Organization/company name", with: "John Hughes Inc."
    fill_in "Job title", with: "Engineer"
    fill_in "Tell us about yourself", with: "I am cool"
    select "I'm new!", from: "In which year did you become a regional ambassador?"

    select "Other", from: "How did you hear about Technovation?"
    fill_in "regional_ambassador_account[referred_by_other]", with: "Some other value"

    click_button "Create Your Account"
  end

  scenario "redirects to dashboard" do
    expect(current_path).to eq(regional_ambassador_dashboard_path)
  end

  scenario "displays a pending approval notice" do
    expect(page).to have_content("Thank you for registering as a Regional Ambassador. Technovation staff will review your account shortly to ensure that your information is correct. Once you are confirmed, you will have access to student data in your region.")
  end

  scenario "saves the custom referral response" do
    expect(RegionalAmbassadorAccount.last.referred_by_other).to eq("Some other value")
  end

  scenario "admins receive an email about it" do
    expect(ActionMailer::Base.deliveries.count).not_to be_zero, "no email sent"

    mail = ActionMailer::Base.deliveries.last

    expect(mail.to).to eq(["info@technovationchallenge.org"])
    expect(mail.body).to include("href=\"#{admin_regional_ambassadors_url(status: :pending)}\"")
  end

  scenario "saves profile data" do
    expect(RegionalAmbassadorAccount.last.ambassador_since_year).to eq("I'm new!")
  end
end
