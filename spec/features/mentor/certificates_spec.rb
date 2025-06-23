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

  scenario "mentor without teams or certificates does not see a certificate link" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    mentor.account.took_program_survey!

    sign_in(mentor)

    click_link "Scores & Certificates"
    click_link "Certificates"
    expect(page).not_to have_link("Open your certificate")

    expect(page).to have_content(
      "You don't have a certificate for this season."
    )
  end

  scenario "mentor with a team and certificate cannot access it before completing the post survey" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    team_a = FactoryBot.create(:team)

    TeamRosterManaging.add(team_a, mentor)
    FactoryBot.create(:team_submission, :complete, team: team_a)

    FillPdfs.call(mentor.account)

    sign_in(mentor)

    click_link "My profile"
    click_link "Scores & Certificates"
    click_link "Certificates"

    expect(page).not_to have_link("Open your certificate")

    expect(page).to have_content("Before you can access your certificate, please complete the post survey")
  end

  scenario "mentor with two teams sees two certificate links after completing the post survey" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    mentor.account.took_program_survey!

    team_a = FactoryBot.create(:team)
    team_b = FactoryBot.create(:team)

    TeamRosterManaging.add(team_a, mentor)
    TeamRosterManaging.add(team_b, mentor)

    FactoryBot.create(:team_submission, :complete, team: team_a)
    FactoryBot.create(:team_submission, :complete, team: team_b)

    expect {
      FillPdfs.call(mentor.account)
    }.to change {
      mentor.certificates.current.mentor_appreciation.count
    }.from(0).to(2)

    sign_in(mentor)
    click_link "My profile"
    click_link "Scores & Certificates"
    click_link "Certificates"

    expect(page).to have_link("Open your certificate", count: 2)
  end
end
