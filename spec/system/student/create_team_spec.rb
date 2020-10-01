require "rails_helper"

RSpec.describe "Students creating a team", :js do
  describe "default team location" do
    it "lets you change the signup form default and sets the team to your change" do
      stub_coordinates([41.50196838, -87.64051818])

      SeasonToggles.enable_signup(:student)
      SeasonToggles.enable_team_building!

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

      fill_in "Team name", with: "Amazing Team!"
      click_button "Create this team"

      click_button "Location"
      expect(page).to have_content("Los Angeles, California, United States")
    end
  end
end