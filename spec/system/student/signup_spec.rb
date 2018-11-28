require "rails_helper"

RSpec.describe "Students signing up", :js do
  describe "authenticating" do
    it "logs in okay with the email / password used during signup" do
      SeasonToggles.enable_signup(:student)

      visit root_path
      click_link "Sign up today"

      check "I agree"
      click_button "Next"

      # TODO - this cannot stand >:[
      sleep 1
      fill_in_vue_select "Country / Territory", with: "United States"
      fill_in_vue_select "State / Province", with: "California"
      fill_in "City", with: "Los Angeles"

      click_button "Next"

      fill_in_vue_select "Year", with: Season.current.year - 11
      fill_in_vue_select "Month", with: "1"
      fill_in_vue_select "Day", with: "1"
      click_button "Next"

      # Choose Profile: Student (auto)
      click_button "Next"

      fill_in "First name(s)", with: "Marge"
      fill_in "Last name(s)", with: "Bouvier"
      fill_in "School name", with: "Springfield Middle School"
      click_button "Next"

      stub_mailgun_validation(valid: true, email: "margeyb@springfield.net")

      fill_in "Email", with: "margeyb@springfield.net"
      fill_in "Password", with: "margeysecret1234"
      click_button "Next"

      click_link "Logout"
      click_link "Sign in"

      fill_in "Email", with: "margeyb@springfield.net"
      fill_in "Password", with: "margeysecret1234"
      click_button "Sign in"

      expect(current_path).to eq(student_dashboard_path)
    end
  end
end