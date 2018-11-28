require "rails_helper"

RSpec.describe "Students creating a team", :js do
  describe "default team location" do
    it "sets the team to your location" do
      SeasonToggles.enable_signup(:student)
      SeasonToggles.enable_team_building!

      visit root_path
      click_link "Sign up today"

      check "I agree"
      click_button "Next"

      fill_in_vue_select "Country / Territory", with: "United States"
      fill_in_vue_select "State / Province", with: "California"
      fill_in "City", with: "Los Angeles"

      click_button "Next"

      fill_in_vue_select "Year", with: Season.current.year - 11
      fill_in_vue_select "Month", with: "1"
      fill_in_vue_select "Day", with: "1"
      click_button "Next"

      # ChooseProfile.vue - student by default, due to age
      click_button "Next"

      fill_in "First name(s)", with: "Marge"
      fill_in "Last name(s)", with: "Bouvier"
      fill_in "School name", with: "Springfield Middle School"
      click_button "Next"

      stub_mailgun_validation(valid: true, email: "margeyb@springfield.net")

      fill_in "Email", with: "margeyb@springfield.net"
      fill_in "Password", with: "margeysecret1234"
      click_button "Next"

      click_button "Create your team"
      within("#create-team") { click_link "Create your team" }

      fill_in "Name", with: "Amazing Team!"
      click_button "Create this team"

      click_button "Location"
      expect(page).to have_content("Los Angeles, California, United States")
    end
  end
end