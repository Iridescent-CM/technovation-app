require "rails_helper"

RSpec.feature "sync background checks" do
  scenario "Admin sync background checks from Checkr in the admin portal", :vcr do
    mentor = FactoryBot.create(
      :mentor,
      :india,
      account: FactoryBot.create(:account, email: "engineering+factorymentor@technovation.org")
    )

    mentor.background_check.destroy

    FactoryBot.create(
      :background_check,
      :invitation_pending,
      account: mentor.account
    )

    sign_in(:admin)

    visit admin_background_checks_path

    expect(page).to have_button("Sync with Checkr")

    mentor.background_check.update(
      invitation_id: "410236366f67d3e3ed14ce1f95036e",
    )

    click_button("Sync with Checkr")

    expect(page).to have_content("All uncleared background checks and all incomplete invitations are being synced. Reload in a minute.")
    within("tr#background_check_#{mentor.background_check.id}") do
      expect(page).to have_css("td.background_check", text: mentor.background_check.status.titleize)
      expect(page).to have_css("td.invitation_status", text: "Expired")
    end
  end
end
