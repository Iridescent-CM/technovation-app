require "rails_helper"

RSpec.feature "Off-season splash page" do
  scenario "when any registration is still enabled" do
    SeasonToggles.disable_signups!

    %w{student mentor judge regional_ambassador}.each do |scope|
      SeasonToggles.enable_signup(scope)
      visit root_path
      expect(page).to have_css("form#new_signup_attempt")
    end
  end

  scenario "when all registrations are disabled" do
    SeasonToggles.disable_signups!
    visit root_path
    expect(page).not_to have_css("form#new_signup_attempt")
    expect(page).to have_content(
      "Registration for Technovation " +
      Season.next.year.to_s +
      " will open on October 1."
    )
  end
end
