require "rails_helper"

RSpec.feature "Register as a judge" do
  before do
    set_signup_token("judge@judge.com")

    visit judge_signup_path

    fill_in "First name", with: "Judge"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    fill_in "Company name", with: "John Hughes Inc."
    fill_in "Job title", with: "Coming of age Storywriter"

    select "Company email", from: "How did you hear about Technovation?"

    click_button "Create Your Account"
  end

  scenario "Redirected to judge dashboard" do
    expect(current_path).to eq(judge_dashboard_path)
  end

  scenario "How did you hear is saved" do
    expect(JudgeProfile.last.referred_by).to eq("Company email")
  end

  scenario "Address info is figured out" do
    click_link "Enter your location now"

    fill_in "City", with: "Chicago"
    fill_in "State / Province", with: "IL"
    select "United States", from: "Country"
    click_button "Save"

    expect(JudgeProfile.last.address_details).to eq("Chicago, IL, United States")
    expect(JudgeProfile.last.account).to be_location_confirmed
  end

  scenario "signup attempt attached" do
    attempt = SignupAttempt.find_by(account_id: JudgeProfile.last.account_id)
    expect(attempt).to be_present
  end
end
