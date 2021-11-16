require "rails_helper"

RSpec.describe "Admin season toggle effects", :js do
  context "Student dashboard" do
    before do
      student = FactoryBot.create(:student, :onboarding)
      sign_in(student)
    end

    it "enables team links" do
      SeasonToggles.team_building_enabled!

      visit student_dashboard_path

      click_button 'Build your team'
      click_button 'Find your team'
      expect(page).to have_link("Find a team")
      expect(page).to have_link("Create your team")
    end

    it "disables team links" do
      SeasonToggles.team_building_disabled!

      visit student_dashboard_path

      click_button 'Build your team'
      click_button 'Find your team'

      expect(page).not_to have_link("Find a team")
      expect(page).not_to have_link("Create your team")
    end
  end
end
