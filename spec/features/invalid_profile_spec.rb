require "rails_helper"

RSpec.feature "Invalid migrated profiles" do
  scenario "A migrated account without geocoding" do
    %w{judge student mentor regional_ambassador}.each do |type|
      account = FactoryGirl.create(type)

      account.update_columns(latitude: nil, longitude: nil, city: nil, state_province: nil)
      account.reload.geocoded = nil

      expect(account).not_to be_valid

      sign_in(account)
      expect(page).to have_current_path(interruptions_path(issue: :invalid_profile))

      click_link "Fix my profile now"

      within(".#{account.type.underscore}_geocoded") do
        expect(page).to have_css('.error', text: "can't be blank")
      end

      sign_out
    end
  end
end
