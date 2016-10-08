require "rails_helper"

RSpec.feature "Register as a mentor" do
  before do
    page.driver.browser.set_cookie("signup_token=#{SignupAttempt.create!(email: "mentor@mentor.com", status: SignupAttempt.statuses[:active]).signup_token}")

    visit mentor_signup_path

    fill_in "First name", with: "Mentor"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    fill_in "Postal code -OR- City & State/Province", with: "Chicago, IL"

    fill_in "School or company name", with: "John Hughes High."
    fill_in "Job title", with: "Janitor / Man of the Year"

    fill_in "Password", with: "secret1234"
    fill_in "Confirm password", with: "secret1234"

    click_button "Sign up"
  end

  scenario "Redirected to mentor dashboard" do
    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "Address details saved" do
    expect(MentorAccount.last.address_details).to eq("Chicago, IL, United States")
  end
end
