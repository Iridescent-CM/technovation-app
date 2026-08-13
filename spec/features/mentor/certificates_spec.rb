require "rails_helper"
require "fill_pdfs"

RSpec.feature "Mentor certificates" do
  before do
    SeasonToggles.display_scores_on!

    allow(Season).to receive(:current).and_return(current_season)
    allow(Season).to receive(:next).and_return(next_season)
  end

  let(:current_season) { instance_double(Season, year: 2026) }
  let(:next_season) { instance_double(Season, year: 2027) }

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
      mentor.certificates.current.mentor.count
    }.from(0).to(2)

    sign_in(mentor)
    click_link "Scores & Certificates"
    click_link "Certificates"

    expect(page).to have_link("Open your certificate", count: 2)
    expect(page).to have_link("Open your letter of recognition")
  end

  scenario "mentor with a letter cannot access it before completing the post survey" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    team_a = FactoryBot.create(:team)

    TeamRosterManaging.add(team_a, mentor)
    FactoryBot.create(:team_submission, :complete, team: team_a)

    FillPdfs.call(mentor.account)

    sign_in(mentor)

    click_link "Scores & Certificates"
    click_link "Certificates"

    expect(page).not_to have_link("Open your letter of recognition")
  end

  scenario "mentor can view their previous mentor certificates" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    previous_certificate = FactoryBot.create(:certificate, :past, :with_file, account: mentor.account, cert_type: :mentor)

    sign_in(mentor)

    click_link "Scores & Certificates"
    click_link "Previous Certificates"

    expect(page).to have_content(previous_certificate.season)
    expect(page).to have_content(previous_certificate.cert_type.titleize)
    expect(page).to have_link("Download your certificate")
  end

  scenario "no previous mentor certificates are displayed when mentor has none" do
    mentor = FactoryBot.create(:mentor, :onboarded)

    sign_in(mentor)

    click_link "Scores & Certificates"
    click_link "Previous Certificates"

    expect(page).to have_content(
      "If you participated in past seasons, this is where you can view and download your certificates."
    )
  end

  scenario "not-onboarded mentor can view and download previous certificates and letters" do
    mentor = FactoryBot.create(:mentor, not_onboarded: true)
    previous_certificate = FactoryBot.create(
      :certificate,
      :past,
      :with_file,
      account: mentor.account,
      cert_type: :mentor
    )
    previous_letter = FactoryBot.create(
      :certificate,
      :past,
      :with_file,
      account: mentor.account,
      cert_type: :mentor_letter,
      team: nil
    )

    sign_in(mentor)

    click_link "Scores & Certificates"
    click_link "Certificates"

    expect(page).to have_content(
      "Reading your scores and certificates is not available right now."
    )

    click_link "Previous Certificates"

    expect(page).to have_content(previous_certificate.season)
    expect(page).to have_content(previous_certificate.cert_type.titleize)
    expect(page).to have_link("Download your certificate", count: 1)

    expect(page).to have_content(previous_letter.season)
    expect(page).to have_content(previous_letter.cert_type.titleize)
    expect(page).to have_link("Download your letter", count: 1)
  end

  scenario "previous certificate without a generated file offers no download link" do
    mentor = FactoryBot.create(:mentor, not_onboarded: true)
    FactoryBot.create(
      :certificate,
      :past,
      account: mentor.account,
      cert_type: :mentor
    )

    sign_in(mentor)

    click_link "Scores & Certificates"
    click_link "Previous Certificates"

    expect(page).not_to have_link("Download your certificate")
    expect(page).to have_content("Unavailable, please contact")
  end

  scenario "not-onboarded mentor opens the previous certificates tab from the scores page", js: true do
    mentor = FactoryBot.create(:mentor, not_onboarded: true)
    FactoryBot.create(
      :certificate,
      :past,
      :with_file,
      account: mentor.account,
      cert_type: :mentor_letter,
      team: nil
    )

    sign_in(mentor)

    click_link "Scores & Certificates"
    click_link "Previous Certificates"

    expect(page).to have_link("Download your letter")
    expect(page).not_to have_content(
      "Reading your scores and certificates is not available right now."
    )
  end
end
