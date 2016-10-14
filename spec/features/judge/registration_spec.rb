require "rails_helper"

RSpec.feature "Register as a judge" do
  before do
    page.driver.browser.set_cookie("signup_token=#{SignupAttempt.create!(email: "judge@judge.com", status: SignupAttempt.statuses[:active]).signup_token}")

    visit judge_signup_path

    fill_in "First name", with: "Judge"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    fill_in "Postal code -OR- City & State/Province", with: 60647

    fill_in "Company name", with: "John Hughes Inc."
    fill_in "Job title", with: "Coming of age Storywriter"

    fill_in "Create a password", with: "secret1234"
    fill_in "Confirm password", with: "secret1234"

    select "Company email", from: "How did you hear about Technovation?"

    click_button "Sign up"
  end

  scenario "Redirected to judge dashboard" do
    expect(current_path).to eq(judge_dashboard_path)
  end

  scenario "How did you hear is saved" do
    expect(JudgeAccount.last.referred_by).to eq("Company email")
  end

  scenario "Address info is figured out" do
    expect(JudgeAccount.last.address_details).to eq("Chicago, IL, United States")
  end
end
