require "rails_helper"

RSpec.describe "Team locations", :js do
  describe "changing an existing team location" do
    it "works fine" do
      team = FactoryBot.create(:team, :chicago)

      sign_in(team.students.sample)
      click_link "My team"

      click_button "Location"
      expect(page).to have_content("Chicago, Illinois, United States")

      click_link "Change this team's location"

      page.find('#location_form_reset').click

      select_vue_select_option "#location_country", option: "United States"
      select_vue_select_option "#location_state", option: "California"
      page.find("#location_city").set("Los Angeles")

      click_button "Next"

      expect(page).to have_content("Los Angeles, California, United States")
    end
  end
end