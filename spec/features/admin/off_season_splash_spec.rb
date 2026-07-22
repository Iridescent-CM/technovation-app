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
    expect(page).to have_content("Thanks for your interest in Technovation Challenge!")
    expect(page).to have_content("Registration for Technovation Challenge will open again by October")
    expect(page).to have_link("sign up", href: "https://eepurl.com/jB3Rxc")
    expect(page).to have_link(
      "curriculum",
      href: "https://technovationchallenge.org/curriculum-intro/registered/new/"
    )
    expect(page).to have_content("Join our community:")
    expect(page).to have_link("Facebook", href: "https://www.facebook.com/technovationglobal")
    expect(page).to have_content("Let's build a better world together!")
    expect(page).not_to have_content("July 12 and Sept 1")
  end
end
