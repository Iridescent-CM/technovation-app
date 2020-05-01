require "rails_helper"
require "fill_pdfs"

RSpec.feature "Judge certificates" do
  scenario "no link available when viewing scores is turned off" do
    SeasonToggles.display_scores_off!

    judge = FactoryBot.create(:judge, :general_certificate)

    FillPdfs.(judge.account)
    sign_in(judge)

    expect(page).not_to have_css("#judge-certificate")
    expect(page).not_to have_link("View your certificate")
  end

  scenario "non-onboarded judges see no certificates or badge" do
    SeasonToggles.display_scores_on!

    judge = FactoryBot.create(:judge)

    FillPdfs.(judge.account)
    sign_in(judge)

    expect(page).not_to have_css("#judge-certificate")
    expect(page).not_to have_link("View your certificate")
  end

  scenario "onboarded judges with no completed scores see no certificates or badge" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded)
    FactoryBot.create(:score, :incomplete, judge_profile: judge)
    FactoryBot.create(:score, :past_season, :complete, judge_profile: judge)

    SeasonToggles.set_judging_round(:off)
    SeasonToggles.display_scores_on!

    FillPdfs.(judge.account)
    sign_in(judge)

    expect(page).not_to have_css("#judge-certificate")
    expect(page).not_to have_link("View your certificate")

    expect(page).to have_content(
      "Thank you for your participation in the #{Season.current.year} " +
      "Technovation season."
    )

    expect(page).to have_content(
      "You can see this year's finalists at " +
      "technovationchallenge.org/season-results"
    )

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

  scenario "judge who is suspended - it doesn't display the certificate's page" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 10)

    SeasonToggles.set_judging_round(:off)
    SeasonToggles.display_scores_on!

    FillPdfs.(judge.account)
    judge.suspend!

    sign_in(judge)
    expect(page).not_to have_css("#judge-certificate")
    expect(page).not_to have_link("View your certificate")
  end

  scenario "judge who doesn't have a certificate - it doesn't display the certficate's page" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 10)

    SeasonToggles.set_judging_round(:off)
    SeasonToggles.display_scores_on!

    FillPdfs.(judge.account)
    judge.account.judge_certificates.destroy_all

    sign_in(judge)
    expect(page).not_to have_css("#judge-certificate")
    expect(page).not_to have_link("View your certificate")
  end

  Array(1..4).each do |n|
    scenario "judge with #{n} completed current scores" do
      SeasonToggles.set_judging_round(:sf)

      judge = FactoryBot.create(:judge, :onboarded, number_of_scores: n)

      SeasonToggles.set_judging_round(:off)
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
      expect(page).not_to have_css("#judge-certificate")
      expect(page).not_to have_link("View your certificate")
    end
  end

  scenario "judge with 5 completed current scores" do
      SeasonToggles.set_judging_round(:sf)

      judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 5)

      SeasonToggles.set_judging_round(:off)
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

      SeasonToggles.set_judging_round(:off)
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

    SeasonToggles.set_judging_round(:off)
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
    expect(page).to have_css("#judge-certificate")
    expect(page).to have_link(
      "View your certificate",
      href: judge.current_judge_advisor_certificates.last.file_url
    )
  end

  scenario "RPE judges get a head judge certificate" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, :attending_live_event)

    SeasonToggles.set_judging_round(:off)
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
    expect(page).to have_css("#judge-certificate")
    expect(page).to have_link(
      "View your certificate",
      href: judge.current_head_judge_certificates.last.file_url
    )
  end

  scenario "RPE judges with more than 10 scores get a judge advisor certificate" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, :attending_live_event, number_of_scores: 11)

    SeasonToggles.set_judging_round(:off)
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
    expect(page).to have_css("#judge-certificate")
    expect(page).to have_link(
      "View your certificate",
      href: judge.current_judge_advisor_certificates.last.file_url
    )
  end
end
