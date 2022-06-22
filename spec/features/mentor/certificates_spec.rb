require "rails_helper"
require "fill_pdfs"

RSpec.feature "Mentor certificates" do
  before do
    SeasonToggles.display_scores_on!

    allow(Season).to receive(:current).and_return(current_season)
    allow(Season).to receive(:next).and_return(next_season)
  end

  let(:current_season) { instance_double(Season, year: 2020) }
  let(:next_season) { instance_double(Season, year: 2021) }

  scenario "no certificates for no teams" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    sign_in(mentor)

    expect(page).not_to have_link("Open your certificate")

    expect(page).to have_content(
      "Thank you for participating in this season of Technovation Girls."
    )

    expect(page).to have_content(
      "Consider mentoring a team in the #{Season.current.year}-#{Season.next.year}"
    )

    expect(page).to have_link(
      "Sign up for our newsletter",
      href: ENV.fetch("NEWSLETTER_URL")
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
