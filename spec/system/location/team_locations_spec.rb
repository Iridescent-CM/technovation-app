require "rails_helper"

RSpec.describe "Team locations", :js do
  describe "changing an existing team location" do
    it "works fine" do
      team = FactoryBot.create(:team, :chicago)

      sign_in(team.students.sample)
      click_link "My Team"

      click_button "Location"
      expect(page).to have_content("Chicago, Illinois, United States")

      click_link "Change this team's location"

      fill_in "State", with: ""
      fill_in "City", with: ""

      fill_in "State", with: "California"
      fill_in "City", with: "Los Angeles"

      click_button "Next"
      expect(page).to have_content("Confirm")

      click_button "Confirm"

      expect(page).to have_content("Los Angeles, California, United States")
    end
  end
end
