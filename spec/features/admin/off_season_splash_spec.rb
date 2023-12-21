require "rails_helper"

RSpec.feature "Off-season splash page" do
  scenario "when any registration is still enabled" do
    SeasonToggles.disable_signups!

    %w[student mentor judge chapter_ambassador].each do |scope|
      SeasonToggles.enable_signup(scope)
      visit root_path
      expect(page).to have_css("#registration-landing")
    end
  end

  scenario "when all registrations are disabled" do
    SeasonToggles.disable_signups!
    visit root_path
    expect(page).not_to have_css("#registration-landing")
    expect(page).to have_content("Registration is currently closed")
  end
end
