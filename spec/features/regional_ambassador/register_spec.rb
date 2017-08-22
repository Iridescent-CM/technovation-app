require "rails_helper"

RSpec.feature "Regional Ambassadors registration" do
  before do
    SeasonToggles.enable_signup(:regional_ambassador)
    set_signup_token("regional@ambassador.com")
    ActionMailer::Base.deliveries.clear

    visit signup_path
    click_link I18n.t("views.signups.new.signup_link.regional_ambassador")

    fill_in "First name", with: "Regional"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    fill_in "Organization/company name", with: "John Hughes Inc."
    fill_in "Job title", with: "Engineer"
    fill_in "Tell us about yourself", with: "I am cool"
    select "I'm new!",
      from: "In which year did you become a regional ambassador?"

    select "Other", from: "How did you hear about Technovation?"
    fill_in "regional_ambassador_profile[account_attributes][referred_by_other]",
      with: "Some other value"

    click_button "Create Your Account"
  end

  scenario "redirects to dashboard" do
    expect(current_path).to eq(regional_ambassador_dashboard_path)
  end

  scenario "displays a pending approval notice" do
    expect(page).to have_content("Thank you for registering as a Regional Ambassador. Technovation staff will review your account shortly to ensure that your information is correct. Once you are confirmed, you will have access to student data in your region.")
  end

  scenario "saves the custom referral response" do
    expect(Account.last.referred_by_other).to eq("Some other value")
  end

  scenario "admins receive an email about it" do
    expect(ActionMailer::Base.deliveries.count).not_to be_zero,
      "no email sent"

    emails = ActionMailer::Base.deliveries

    expect(emails.collect(&:to)).to include([
      "mailer@technovationchallenge.org"
    ])
  end

  scenario "saves profile data" do
    expect(RegionalAmbassadorProfile.last.ambassador_since_year).to eq(
      "I'm new!"
    )
  end

  scenario "saves location details" do
    click_link "Update your location"

    fill_in "City", with: "Chicago"
    fill_in "State / Province", with: "IL"
    select "United States", from: "Country"
    click_button "Save"

    expect(
      RegionalAmbassadorProfile.last.address_details
    ).to eq("Chicago, IL, United States")

    expect(RegionalAmbassadorProfile.last.account).to be_location_confirmed
  end

  scenario "signup attempt attached" do
    attempt = SignupAttempt.find_by(
      account_id: RegionalAmbassadorProfile.last.account_id
    )
    expect(attempt).to be_present
  end
end
