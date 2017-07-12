require "rails_helper"

RSpec.feature "Admin UI for season toggles:" do
  scenario "toggle user signups" do
    sign_in(FactoryGirl.create(:admin))
    click_link "Season Schedule Settings"

    %w{student mentor judge regional_ambassador}.each do |scope|
      SeasonToggles.disable_signup(scope)
      click_link "Season Schedule Settings"

      check "#{scope.humanize.capitalize} signup"
      click_button "Save"

      expect(SeasonToggles.signup_enabled?(scope)).to be(true),
        "#{scope} signup was not enabled"
    end
  end
end
