require "rails_helper"

RSpec.feature "Register as a mentor" do
  before do
    Season.create_current
    visit mentor_signup_path

    fill_in "First name", with: "Mentor"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    select "United States", from: "Country"
    fill_in "State / Province", with: "IL"
    fill_in "City", with: "Chicago"

    fill_in "School or company name", with: "John Hughes High."
    fill_in "Job title", with: "Janitor / Man of the Year"

    fill_in "Email", with: "mentor@mentor.com"
    fill_in "Password", with: "secret1234"
    fill_in "Confirm password", with: "secret1234"

    click_button "Sign up"
  end

  scenario "Redirected to mentor dashboard" do
    expect(current_path).to eq(mentor_dashboard_path)
  end
end
