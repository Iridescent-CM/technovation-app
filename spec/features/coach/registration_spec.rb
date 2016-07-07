require "rails_helper"

RSpec.feature "Register as a coach" do
  before do
    visit coach_signup_path

    fill_in "First name", with: "Coach"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    select "United States", from: "Country"
    fill_in "State / Province", with: "IL"
    fill_in "City", with: "Chicago"

    fill_in "School or company name", with: "John Hughes High."
    fill_in "Job title", with: "Janitor / Man of the Year"

    fill_in "Email", with: "coach@coach.com"
    fill_in "Password", with: "secret1234"
    fill_in "Confirm password", with: "secret1234"

    click_button "Sign up"
  end

  scenario "Redirected to coach dashboard" do
    expect(current_path).to eq(coach_dashboard_path)
  end
end
