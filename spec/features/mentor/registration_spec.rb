require "rails_helper"

RSpec.feature "Register as a mentor" do
  before do
    token = FactoryGirl.create(:signup_attempt, email: "mentor@mentor.com").signup_token
    page.driver.browser.set_cookie("signup_token=#{token}")

    visit mentor_signup_path

    fill_in "First name", with: "Mentor"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    fill_in "School or company name", with: "John Hughes High."
    fill_in "Job title", with: "Janitor / Man of the Year"

    click_button "Create Your Account"
  end

  scenario "Redirected to mentor dashboard" do
    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "saves location details" do
    click_link "Enter your location now"

    fill_in "City", with: "Chicago"
    fill_in "State / Province", with: "IL"
    select "United States", from: "Country"
    click_button "Confirm location details"

    expect(MentorProfile.last.address_details).to eq("Chicago, IL, United States")
    expect(MentorProfile.last.account).to be_location_confirmed
  end
end
