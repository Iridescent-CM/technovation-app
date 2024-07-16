require "rails_helper"

RSpec.feature "Background check exemptions" do
  let(:admin) { FactoryBot.create(:admin) }

  %i[mentor chapter_ambassador].each do |scope|
    scenario "Admin grants a background check exemption for a #{scope}" do
      profile = FactoryBot.create(scope)
      profile.background_check.destroy

      sign_in(admin)
      visit admin_participant_path(profile.account)

      expect(page).to have_content("#{profile.account.full_name} is in a country that requires a background check")
      click_link "Exempt from background check requirement"

      profile.reload

      expect(current_path).to eq(admin_participant_path(profile.account))
      expect(page).to have_text("They currently have a background check exemption.")
      expect(page).to have_link("Revoke background check exemption")
    end

    scenario "Admin grants a background check exemption for a #{scope}" do
      profile = FactoryBot.create(scope)
      profile.background_check.destroy

      profile.account.update(background_check_exemption: true)

      sign_in(admin)
      visit admin_participant_path(profile.account)

      expect(page).to have_text("They currently have a background check exemption.")
      click_link "Revoke background check exemption"

      profile.reload

      expect(current_path).to eq(admin_participant_path(profile.account))
      expect(page).to have_content("#{profile.account.full_name} is in a country that requires a background check")
      expect(page).to have_link("Exempt from background check requirement")
    end
  end
end
