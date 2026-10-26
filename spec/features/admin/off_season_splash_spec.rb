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
    expect(page).to have_content("Technovation Challenge")
    expect(page).to have_content("Our new home is open.")
    expect(page).not_to have_content("Registration is currently closed")
    expect(page).to have_content(
      "Thanks for your interest in Technovation Challenge! We can't wait for you to be part of our global community!"
    )
    expect(page).to have_content("Technovation has moved to")
    expect(page).to have_content("Sign in or sign up there to get started.")
    expect(page).to have_content(
      "Technovation builds innovators for life. At every stage of life, we help you solve real problems with technology and cultivate the power to choose your own purpose and future. You don't have to have it figured out yet. Come build."
    )
    expect(page).to have_link("my.technovation.org", href: "https://my.technovation.org")
    expect(page).to have_link("Go to my.technovation.org", href: "https://my.technovation.org")
    expect(page).to have_content("Join our community:")
    expect(page).to have_link("Facebook", href: "https://www.facebook.com/technovationglobal")
    within("ul.unstyled") do
      expect(page).to have_link("X", href: "https://x.com/technovation")
      expect(page).to have_css("svg")
      expect(page).not_to have_css(".icon-twitter-square")
    end
    expect(page).to have_css("img[alt='X'][src*='x']")
    expect(page).not_to have_link(href: "https://twitter.com/technovation")
    expect(page).not_to have_content("Registration for Technovation Challenge will open again by October")
    expect(page).not_to have_content("Let's build a better world together!")
    expect(page).not_to have_link("sign up", href: "https://eepurl.com/jB3Rxc")
    expect(page).not_to have_link(
      "curriculum",
      href: "https://technovationchallenge.org/curriculum-intro/registered/new/"
    )
    expect(page).not_to have_link("Twitter")
    expect(page).not_to have_content("July 12 and Sept 1")
  end
end
