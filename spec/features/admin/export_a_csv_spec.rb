require "rails_helper"

RSpec.feature "Admin exporting a CSV", js: true do
  context "from the Participants page" do
    let(:admin) { FactoryBot.create(:admin) }
    let!(:student) { FactoryBot.create(:student, :onboarded) }

    before {
      sign_in(admin)
      visit admin_participants_path
      click_link "Export current results to CSV"
      click_button "Export now"
    }

    scenario "sees a confirmation dialog" do
      within("#queued-jobs") do
        expect(page).to have_content("Your file is ready!")
        expect(page).to have_link("Download")
        expect(page).to have_link("I no longer need this file")
      end
    end

    scenario "clears the confirmation dialog" do
      within("#queued-jobs") do
        click_link "I no longer need this file"
      end

      expect(page).not_to have_css("#queued-jobs")
    end
  end
end
