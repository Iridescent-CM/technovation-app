require "rails_helper"
require "fill_pdfs"

RSpec.feature "Judge certificates" do
  let(:season_with_templates) { instance_double(Season, year: 2020) }

  before do
    allow(Season).to receive(:current).and_return(season_with_templates)
  end

  scenario "Certificate is unavailable when judging is set to off and viewing scores and certs is turned off" do
    SeasonToggles.set_judging_round(:off)
    SeasonToggles.display_scores_off!

    judge = FactoryBot.create(:judge,:onboarded,:general_certificate)

    FillPdfs.(judge.account)
    sign_in(judge)

    click_link("dashboard-tab")
    expect(page).to have_content("Welcome to the online judging portal! Judging is currently closed but will open soon.")

    click_link "Your judge certificate"
    expect(page).to have_content("Certificates are currently unavailable.")
  end

  scenario "Certificate is unavailable when judging is set to QF and viewing scores and certs is turned off" do
    SeasonToggles.set_judging_round(:qf)
    SeasonToggles.display_scores_off!

    judge = FactoryBot.create(:judge,:onboarded,:general_certificate)

    FillPdfs.(judge.account)
    sign_in(judge)

    click_link("dashboard-tab")
    expect(page).to have_content("Welcome to the online judging portal for the first round of Technovation Judging!")

    click_link "Your judge certificate"
    expect(page).to have_content("Certificates are currently unavailable.")
  end

  scenario "Certificate is unavailable when judging is set to SF and viewing scores and certs is turned off" do
    SeasonToggles.set_judging_round(:sf)
    SeasonToggles.display_scores_off!

    judge = FactoryBot.create(:judge,:onboarded,:general_certificate)

    FillPdfs.(judge.account)
    sign_in(judge)

    click_link("dashboard-tab")
    expect(page).to have_content("Welcome to the second round of online judging, also known as Semifinals!")

    click_link "Your judge certificate"
    expect(page).to have_content("Certificates are currently unavailable.")
  end

  scenario "Certificate is unavailable when judging is set to finished and viewing scores and certs is turned off" do
    SeasonToggles.set_judging_round(:finished)
    SeasonToggles.display_scores_off!

    judge = FactoryBot.create(:judge,:onboarded,:general_certificate)

    FillPdfs.(judge.account)
    sign_in(judge)

    click_link("dashboard-tab")
    expect(page).to have_content("Thank you for your help scoring and giving valuable feedback to Technovation teams.")

    click_link "Your judge certificate"
    expect(page).to have_content("Certificates are currently unavailable.")
  end

  scenario "non-onboarded judges see no certificates when judging is set to finished" do
    SeasonToggles.set_judging_round(:finished)
    SeasonToggles.display_scores_on!

    judge = FactoryBot.create(:judge)
    sign_in(judge)

    expect(page).to have_content("Thank you for your interest in judging this season. The season is currently finished.")
    expect(page).not_to have_link("Your judge certificate")
  end

  scenario "onboarded judges with no completed scores see no certificates or badge" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded)
    FactoryBot.create(:score, :incomplete, judge_profile: judge)
    FactoryBot.create(:score, :past_season, :complete, judge_profile: judge)

    SeasonToggles.set_judging_round(:finished)
    SeasonToggles.display_scores_on!

    FillPdfs.(judge.account)
    sign_in(judge)

    expect(page).to have_content(
      "Thank you for participating in this season of Technovation Girls."
    )

    expect(page).to have_content(
      "Did you enjoy the submissions you reviewed?"
    )

    expect(page).to have_content(
      "Sign up for our newsletter to learn more about the girls you helped this season"
    )

    expect(page).to have_link(
      "Consider mentoring",
      href: "https://technovationchallenge.org/get-started/"
    )

    expect(page).to have_link(
      "Sign up for our newsletter",
      href: ENV.fetch("GENERAL_NEWSLETTER_URL")
    )

    click_link "Your judge certificate"
    expect(page).to have_content("You don't have a certificate for this season.")
  end

  scenario "judge who is suspended - it doesn't display the certificate's page" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 10)

    SeasonToggles.set_judging_round(:finished)
    SeasonToggles.display_scores_on!

    FillPdfs.(judge.account)
    judge.suspend!

    sign_in(judge)
    expect(page).not_to have_link("View judge certificate")
  end

  scenario "judge who doesn't have a certificate - Displays 'no certificate' text" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 10)

    SeasonToggles.set_judging_round(:finished)
    SeasonToggles.display_scores_on!

    FillPdfs.(judge.account)
    judge.account.judge_certificates.destroy_all

    sign_in(judge)
    click_link "Your judge certificate"
    expect(page).to have_content("You don't have a certificate for this season.")
  end

  Array(1..4).each do |n|
    scenario "judge with #{n} completed current scores" do
      SeasonToggles.set_judging_round(:sf)

      judge = FactoryBot.create(:judge, :onboarded, number_of_scores: n)

      SeasonToggles.set_judging_round(:finished)
      SeasonToggles.display_scores_on!

      expect {
        FillPdfs.(judge.account)
      }.to not_change {
        judge.current_general_judge_certificates.count
      }.and not_change {
        judge.current_certified_judge_certificates.count
      }.and not_change {
        judge.current_head_judge_certificates.count
      }.and not_change {
        judge.current_judge_advisor_certificates.count
      }

      sign_in(judge)
      expect(page).not_to have_link("View your certificate")
    end
  end

  scenario "judge with 5 completed current scores" do
      SeasonToggles.set_judging_round(:sf)

      judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 5)

      SeasonToggles.set_judging_round(:finished)
      SeasonToggles.display_scores_on!

      expect {
        FillPdfs.(judge.account)
      }.to change {
        judge.current_certified_judge_certificates.count
      }.from(0).to(1).and not_change {
        judge.current_general_judge_certificates.count
      }.and not_change {
        judge.current_head_judge_certificates.count
      }.and not_change {
        judge.current_judge_advisor_certificates.count
      }

      sign_in(judge)
      click_link "Your judge certificate"
      expect(page).to have_css("#judge-certificate")
      expect(page).to have_link(
        "View your certificate",
        href: judge.current_certified_judge_certificates.last.file_url
      )
  end

  Array(6..10).each do |n|
    scenario "judge with #{n} completed current scores" do
      SeasonToggles.set_judging_round(:sf)

      judge = FactoryBot.create(:judge, :onboarded, number_of_scores: n)

      SeasonToggles.set_judging_round(:finished)
      SeasonToggles.display_scores_on!

      expect {
        FillPdfs.(judge.account)
      }.to change {
        judge.current_head_judge_certificates.count
      }.from(0).to(1)
      .and not_change {
        judge.current_certified_judge_certificates.count
      }.and not_change {
        judge.current_general_judge_certificates.count
      }

      sign_in(judge)
      expect(page).to have_css("#judge-certificate")
      expect(page).to have_link(
        "View your certificate",
        href: judge.current_head_judge_certificates.last.file_url
      )
    end
  end

  scenario "judge with 11 or more completed current scores" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 11)

    SeasonToggles.set_judging_round(:finished)
    SeasonToggles.display_scores_on!

    expect {
      FillPdfs.(judge.account)
    }.to change {
      judge.current_judge_advisor_certificates.count
    }.from(0).to(1)
    .and not_change {
      judge.current_head_judge_certificates.count
    }.and not_change {
      judge.current_certified_judge_certificates.count
    }.and not_change {
      judge.current_general_judge_certificates.count
    }

    sign_in(judge)
    click_link "Your judge certificate"
    expect(page).to have_css("#judge-certificate")
    expect(page).to have_link(
      "View your certificate",
      href: judge.current_judge_advisor_certificates.last.file_url
    )
  end

  scenario "RPE judges get a head judge certificate" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, :attending_live_event)

    SeasonToggles.set_judging_round(:finished)
    SeasonToggles.display_scores_on!

    expect {
      FillPdfs.(judge.account)
    }.to change {
      judge.current_head_judge_certificates.count
    }.from(0).to(1)
    .and not_change {
      judge.current_judge_advisor_certificates.count
    }.and not_change {
      judge.current_certified_judge_certificates.count
    }.and not_change {
      judge.current_general_judge_certificates.count
    }

    sign_in(judge)
    click_link "Your judge certificate"
    expect(page).to have_css("#judge-certificate")
    expect(page).to have_link(
      "View your certificate",
      href: judge.current_head_judge_certificates.last.file_url
    )
  end

  scenario "RPE judges with more than 10 scores get a judge advisor certificate" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, :attending_live_event, number_of_scores: 11)

    SeasonToggles.set_judging_round(:finished)
    SeasonToggles.display_scores_on!

    expect {
      FillPdfs.(judge.account)
    }.to change {
      judge.current_judge_advisor_certificates.count
    }.from(0).to(1)
    .and not_change {
      judge.current_head_judge_certificates.count
    }.and not_change {
      judge.current_certified_judge_certificates.count
    }.and not_change {
      judge.current_general_judge_certificates.count
    }

    sign_in(judge)
    click_link "Your judge certificate"
    expect(page).to have_css("#judge-certificate")
    expect(page).to have_link(
      "View your certificate",
      href: judge.current_judge_advisor_certificates.last.file_url
    )
  end
end
