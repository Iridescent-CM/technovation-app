require "rails_helper"

RSpec.feature "Register as a judge" do
  before do
    visit judge_signup_path

    fill_in "First name", with: "Judge"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    select "United States", from: "Country"
    fill_in "State / Province", with: "IL"
    fill_in "City", with: "Chicago"

    fill_in "Company name", with: "John Hughes Inc."
    fill_in "Job title", with: "Coming of age Storywriter"

    fill_in "Email", with: "judge@judge.com"
    fill_in "Password", with: "secret1234"
    fill_in "Confirm password", with: "secret1234"

    select "Company email", from: "How did you hear about us?"

    click_button "Sign up"
  end

  scenario "Redirected to judge dashboard" do
    expect(current_path).to eq(judge_dashboard_path)
  end

  scenario "How did you hear is saved" do
    expect(JudgeAccount.last.referred_by).to eq("Company email")
  end
end
