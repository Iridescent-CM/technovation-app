require "rails_helper"

RSpec.feature "Judge certificates" do
  scenario "no link available when viewing scores is turned off" do
    SeasonToggles.display_scores_off!

    judge = FactoryBot.create(:judge, :general_certificate)

    sign_in(judge)

    expect(page).not_to have_css("#judge-certificate")
    expect(page).not_to have_link("View your certificate")
  end

  scenario "non-onboarded judges see no certificates or badge" do
    SeasonToggles.display_scores_on!

    judge = FactoryBot.create(:judge)

    sign_in(judge)

    expect(page).not_to have_css("#judge-certificate")
    expect(page).not_to have_link("View your certificate")
  end

  scenario "onboarded judges with no completed scores see no certificates or badge" do
    SeasonToggles.display_scores_on!

    judge = FactoryBot.create(:judge, :onboarded)
    FactoryBot.create(:score, :incomplete, judge_profile: judge)
    FactoryBot.create(:score, :past_season, :complete, judge_profile: judge)

    sign_in(judge)

    expect(page).not_to have_css("#judge-certificate")
    expect(page).not_to have_link("View your certificate")
  end

  Array(1..4).each do |n|
    scenario "judge with #{n} completed current scores" do
      SeasonToggles.display_scores_on!

      judge = FactoryBot.create(:judge, :onboarded, number_of_scores: n)

      expect {
        sign_in(judge)
      }.to change {
        judge.current_general_judge_certificates.count
      }.from(0).to(1).and not_change {
        judge.current_certified_judge_certificates.count
      }.and not_change {
        judge.current_head_judge_certificates.count
      }.and not_change {
        judge.current_judge_advisor_certificates.count
      }

      expect(page).to have_css("#judge-certificate")
      expect(page).to have_link(
        "View your certificate",
        href: judge.current_general_judge_certificates.last.file_url
      )
    end
  end

  scenario "judge with 5 completed current scores" do
      SeasonToggles.display_scores_on!

      judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 5)

      expect {
        sign_in(judge)
      }.to change {
        judge.current_certified_judge_certificates.count
      }.from(0).to(1).and not_change {
        judge.current_general_judge_certificates.count
      }.and not_change {
        judge.current_head_judge_certificates.count
      }.and not_change {
        judge.current_judge_advisor_certificates.count
      }

      expect(page).to have_css("#judge-certificate")
      expect(page).to have_link(
        "View your certificate",
        href: judge.current_certified_judge_certificates.last.file_url
      )
  end

  Array(6..10).each do |n|
    scenario "judge with #{n} completed current scores" do
      SeasonToggles.display_scores_on!

      judge = FactoryBot.create(:judge, :onboarded, number_of_scores: n)

      expect {
        sign_in(judge)
      }.to change {
        judge.current_head_judge_certificates.count
      }.from(0).to(1)
      .and not_change {
        judge.current_certified_judge_certificates.count
      }.and not_change {
        judge.current_general_judge_certificates.count
      }

      expect(page).to have_css("#judge-certificate")
      expect(page).to have_link(
        "View your certificate",
        href: judge.current_head_judge_certificates.last.file_url
      )
    end
  end

  scenario "judge with 10 or more completed current scores" do
    SeasonToggles.display_scores_on!

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 11)

    expect {
      sign_in(judge)
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

    expect(page).to have_css("#judge-certificate")
    expect(page).to have_link(
      "View your certificate",
      href: judge.current_judge_advisor_certificates.last.file_url
    )
  end

  scenario "RPE judges get a head judge certificate" do
    SeasonToggles.display_scores_on!

    judge = FactoryBot.create(:judge, :onboarded, :attending_live_event)

    expect {
      sign_in(judge)
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

    expect(page).to have_css("#judge-certificate")
    expect(page).to have_link(
      "View your certificate",
      href: judge.current_head_judge_certificates.last.file_url
    )
  end

  scenario "RPE judges with more than 10 scores get a judge advisor certificate" do
    SeasonToggles.display_scores_on!

    judge = FactoryBot.create(:judge, :onboarded, :attending_live_event, number_of_scores: 11)

    expect {
      sign_in(judge)
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

    expect(page).to have_css("#judge-certificate")
    expect(page).to have_link(
      "View your certificate",
      href: judge.current_judge_advisor_certificates.last.file_url
    )
  end
end