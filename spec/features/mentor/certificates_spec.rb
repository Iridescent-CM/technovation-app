require "rails_helper"

RSpec.feature "Mentor certificates" do
  before  { SeasonToggles.display_scores_on! }

  scenario "no certificates for no teams" do
    mentor = FactoryBot.create(:mentor)

    sign_in(mentor)

    expect(page).not_to have_link("Open your certificate")

    expect(page).to have_content(
      "Thank you for your participation in the #{Season.current.year} " +
      "Technovation season. Check out the finalists at " +
      "technovationchallenge.org/season-results"
    )

    expect(page).to have_content(
      "The #{Season.next.year} season will open in the Fall. " +
      "Sign up for our newsletter to stay in the loop about important dates " +
      "and updates."
    )

    expect(page).to have_link(
      "Sign up for our newsletter",
      href: ENV.fetch("NEWSLETTER_URL")
    )

    expect(page).to have_link(
      "technovationchallenge.org/season-results",
      href: ENV.fetch("FINALISTS_URL")
    )
  end
end
