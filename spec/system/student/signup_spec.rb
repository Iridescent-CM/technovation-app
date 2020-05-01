require "rails_helper"

RSpec.describe "Students signing up", :js do
  describe "authenticating" do
    it "logs in okay with the email / password used during signup" do
      SeasonToggles.enable_signup(:student)

      visit root_path
      click_link "Sign up today"

      check "I agree"
      click_button "Next"

      fill_in "State / Province", with: "California"
      fill_in "City", with: "Los Angeles"
      fill_in "Country", with: "United States"

      click_button "Next"
      click_button "Confirm"

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

      fill_in "Email", with: "margeyb@springfield.net"
      fill_in "Password", with: "margeysecret1234"
      click_button "Sign in"

      expect(current_path).to eq(student_dashboard_path)
    end
  end

  describe "location form" do
    it "lets you change its guess" do
      allow(CookiedCoordinates).to receive(:get).and_return(
        [41.50196838, -87.64051818]
      )

      SeasonToggles.enable_signup(:student)

      visit root_path
      click_link "Sign up today"

      check "I agree"
      click_button "Next"

      expect(page).to have_selector('#location_city', visible: true)
      expect(page).to have_selector('#location_state', visible: true)
      expect(page).to have_selector('#location_country', visible: true)

      expect(page.find('#location_city').value).to eq("Chicago")

      fill_in "State / Province", with: "CA"
      fill_in "City", with: "Los Angeles"

      click_button "Next"
      click_button "Confirm"

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

      click_button "Profile"
      click_button "Region"

      expect(page.find('#location_city').value).to eq("Los Angeles")
    end
  end
end