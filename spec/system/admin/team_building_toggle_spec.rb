require "rails_helper"

RSpec.describe "Admin season toggle effects", :js do
  context "Student dashboard" do
    before do
      student = FactoryBot.create(:student, :onboarded)
      sign_in(student)
    end

    it "enables team links" do
      SeasonToggles.team_building_enabled!

      visit student_dashboard_path

      click_link "Find your team"
      expect(page).to have_link("Find a team")
      expect(page).to have_link("Create your team")
    end

    it "disables team links" do
      SeasonToggles.team_building_disabled!

      visit student_dashboard_path

      click_link "Find your team"
      expect(page).to have_content("Responding to team invites is not available right now.")
    end
  end
end
