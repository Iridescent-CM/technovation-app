require "rails_helper"

RSpec.feature "Admin UI for season toggles:" do
  before do
    sign_in(FactoryGirl.create(:admin))
    click_link "Season Schedule Settings"
  end

  scenario "toggle user signups" do
    %w{student mentor judge regional_ambassador}.each do |scope|
      SeasonToggles.disable_signup(scope)
      click_link "Season Schedule Settings"

      check "#{scope.humanize.capitalize} signup"
      click_button "Save"

      expect(SeasonToggles.signup_enabled?(scope)).to be(true),
        "#{scope} signup was not enabled"
    end
  end

  scenario "set dashboard headlines" do
    %w{student mentor judge}.each do |scope|
      SeasonToggles.set_dashboard_text(scope, "")
      click_link "Season Schedule Settings"

      fill_in "#{scope.humanize.capitalize} dashboard text",
        with: "Something short"

      click_button "Save"

      expect(SeasonToggles.dashboard_text(scope)).to eq("Something short"),
        "#{scope} dashboard text was not set"
    end
  end
end
