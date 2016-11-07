require "rails_helper"

RSpec.feature "Invalid migrated profiles" do
  scenario "A migrated account without geocoding" do
    %w{judge student mentor regional_ambassador}.each do |type|
      profile = FactoryGirl.create(type)

      profile.account.update_columns(latitude: nil, longitude: nil, city: nil, state_province: nil)
      profile.reload.account.geocoded = nil

      expect(profile).not_to be_valid

      sign_in(profile)
      expect(page).to have_current_path(interruptions_path(issue: :invalid_profile))

      click_link "Fix my profile now"

      within(".#{profile.type_name.underscore}_profile_account_geocoded") do
        expect(page).to have_css('.error', text: "can't be blank")
      end

      sign_out
    end
  end
end
