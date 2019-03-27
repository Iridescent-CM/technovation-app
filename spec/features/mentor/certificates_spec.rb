require "rails_helper"
require "fill_pdfs"

RSpec.feature "Mentor certificates" do
  before  { SeasonToggles.display_scores_on! }

  scenario "no certificates for no teams" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    sign_in(mentor)

    expect(page).not_to have_link("Open your certificate")

    expect(page).to have_content(
      "Thank you for your participation in the #{Season.current.year} " +
      "Technovation season."
    )

    expect(page).to have_content(
      "You can see this year's finalists at " +
      "technovationchallenge.org/season-results")

    expect(page).to have_content(
      "The #{Season.next.year} season will open in the Fall."
    )

    expect(page).to have_content(
      "Stay informed about important dates and updates. " +
      "Sign up for our newsletter."
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

  scenario "appreciation certificate per team" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    team_a = FactoryBot.create(:team)
    team_b = FactoryBot.create(:team)

    TeamRosterManaging.add(team_a, mentor)
    TeamRosterManaging.add(team_b, mentor)

    expect {
      FillPdfs.(mentor.account, team: team_a)
      FillPdfs.(mentor.account, team: team_b)
    }.to change {
      mentor.certificates.current.mentor_appreciation.count
    }.from(0).to(2)

    sign_in(mentor)

    expect(page).to have_link("Open your certificate", count: 2)
  end
end
