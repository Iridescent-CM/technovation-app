require "rails_helper"

RSpec.describe "Mentors signing up", :js do
  describe "authenticating" do
    it "logs in okay with the email / password used during signup" do
      SeasonToggles.enable_signup(:mentor)
      expertise = FactoryBot.create(:expertise)

      visit root_path
      click_link "Sign up today"

      check "I agree"
      click_button "Next"

      fill_in "State / Province", with: "California"
      fill_in "City", with: "Los Angeles"
      fill_in "Country", with: "United States"

      click_button "Next"
      click_button "Confirm"

      fill_in_vue_select "Year", with: Season.current.year - 21
      fill_in_vue_select "Month", with: "1"
      fill_in_vue_select "Day", with: "1"
      click_button "Next"

      # Choose Profile: Mentor (auto)
      click_button "Next"

      fill_in "First name(s)", with: "Marge"
      fill_in "Last name(s)", with: "Bouvier"
      fill_in_vue_select "Gender identity", with: "Female"
      fill_in_vue_select "School or company name", with: "Springfield Nuclear Power Plant"
      fill_in "Job title", with: "Saftey inspector"

      fill_in_vue_select "As a mentor, you may call me a(n)...",
        with: "Industry professional"

      check expertise.name

      click_button "Next"

      stub_mailgun_validation(valid: true, email: "margeyb@springfield.net")

      fill_in "Email", with: "margeyb@springfield.net"
      fill_in "Password", with: "margeysecret1234"
      click_button "Next"

      click_link "Logout"

      fill_in "Email", with: "margeyb@springfield.net"
      fill_in "Password", with: "margeysecret1234"
      click_button "Sign in"

      expect(current_path).to eq(mentor_dashboard_path)
    end
  end
end