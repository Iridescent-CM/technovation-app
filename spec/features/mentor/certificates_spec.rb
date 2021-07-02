require "rails_helper"
require "fill_pdfs"

RSpec.feature "Mentor certificates" do
  before  { SeasonToggles.display_scores_on! }
  let(:season_with_templates) { instance_double(Season, year:2020) }
  before { allow(Season).to receive(:current).and_return(season_with_templates) }

  scenario "no certificates for no teams" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    sign_in(mentor)

    expect(page).not_to have_link("Open your certificate")

    expect(page).to have_content(
      "Thank you for participating in this season of Technovation Girls."
    )

    expect(page).to have_content(
      "You can see this year's finalists here."
    )

    expect(page).to have_link(
      "here",
      href: ENV.fetch("FINALISTS_URL")
    )

    expect(page).to have_content(
      "The next season will open in the Fall of #{Season.current.year}."
    )

    expect(page).to have_content(
      "Stay informed about important dates and updates. Sign up for our newsletter."
    )

    expect(page).to have_link(
      "Sign up for our newsletter",
      href: ENV.fetch("NEWSLETTER_URL")
    )

    expect(page).to have_content(
      "Questions or feedback about staying involved with Technovation, reach out to support@technovation.org."
    )

    expect(page).to have_content(
      "Make sure to visit Technovation's blog for program updates and announcements."
    )

    expect(page).to have_link(
      "Technovation's blog",
      href: "https://www.technovation.org/blog/"
    )
  end

  scenario "appreciation certificate per team" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    team_a = FactoryBot.create(:team)
    team_b = FactoryBot.create(:team)

    TeamRosterManaging.add(team_a, mentor)
    TeamRosterManaging.add(team_b, mentor)

    FactoryBot.create(:team_submission, :complete, team: team_a)
    FactoryBot.create(:team_submission, :complete, team: team_b)

    expect {
      FillPdfs.(mentor.account)
    }.to change {
      mentor.certificates.current.mentor_appreciation.count
    }.from(0).to(2)

    sign_in(mentor)

    expect(page).to have_link("Open your certificate", count: 2)
  end
end
