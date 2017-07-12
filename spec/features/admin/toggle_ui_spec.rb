require "rails_helper"

RSpec.feature "Admin UI for season toggles:" do
  scenario "toggle user signups" do
    sign_in(FactoryGirl.create(:admin))
    click_link "Season Schedule Settings"

    %w{student mentor judge regional_ambassador}.each do |scope|
      SeasonToggles.public_send("#{scope}_signup=", false)
      click_link "Season Schedule Settings"

      check "#{scope.humanize.capitalize} signup"
      click_button "Save"

      expect(SeasonToggles.public_send("#{scope}_signup?")).to be(true),
        "#{scope} signup was not enabled"
    end
  end
end
