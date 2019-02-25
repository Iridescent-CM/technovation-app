require "rails_helper"

RSpec.feature "Admins viewing past judge certificates" do
  scenario "non-onboarded judges have no certificates or badge" do
    judge = FactoryBot.create(:judge)

    sign_in(:admin)

    click_link "Participants"

    within_results_page_with("#account_#{judge.account_id}") do
      click_link "view"
    end

    expect(page).not_to have_css(".judge-certificate")
    expect(page).not_to have_link("View #{judge.seasons.last} certificate")
  end

  scenario "onboarded judges with no completed scores have no certificates or badge" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded)
    FactoryBot.create(:score, :incomplete, judge_profile: judge)

    SeasonToggles.set_judging_round(:off)

    sign_in(:admin)

    click_link "Participants"

    within_results_page_with("#account_#{judge.account_id}") do
      click_link "view"
    end

    expect(page).not_to have_css(".judge-certificate")
    expect(page).not_to have_link("View #{judge.seasons.last} certificate")
  end

  scenario "judge with 1 - 4 completed current scores" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: Array(1..4).sample)

    SeasonToggles.set_judging_round(:off)

    expect {
      sign_in(:admin)

      click_link "Participants"

      within_results_page_with("#account_#{judge.account_id}") do
        click_link "view"
      end
    }.to change {
      judge.current_general_judge_certificates.count
    }.from(0).to(1).and not_change {
      judge.current_certified_judge_certificates.count
    }.and not_change {
      judge.current_head_judge_certificates.count
    }.and not_change {
      judge.current_judge_advisor_certificates.count
    }

    expect(page).to have_css(".judge-certificate")
    expect(page).to have_link(
      "View #{judge.seasons.last} certificate",
      href: judge.current_general_judge_certificates.last.file_url
    )
  end

  scenario "judge with 5 completed current scores" do
      SeasonToggles.set_judging_round(:sf)

      judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 5)

      SeasonToggles.set_judging_round(:off)

      expect {
        sign_in(:admin)

        click_link "Participants"

        within_results_page_with("#account_#{judge.account_id}") do
          click_link "view"
        end
      }.to change {
        judge.current_certified_judge_certificates.count
      }.from(0).to(1).and not_change {
        judge.current_general_judge_certificates.count
      }.and not_change {
        judge.current_head_judge_certificates.count
      }.and not_change {
        judge.current_judge_advisor_certificates.count
      }

      expect(page).to have_css(".judge-certificate")
      expect(page).to have_link(
        "View #{judge.seasons.last} certificate",
        href: judge.current_certified_judge_certificates.last.file_url
      )
  end

  scenario "judge with 6 to 10 completed current scores" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: Array(6..10).sample)

    SeasonToggles.set_judging_round(:off)

    expect {
      sign_in(:admin)

      click_link "Participants"

      within_results_page_with("#account_#{judge.account_id}") do
        click_link "view"
      end
    }.to change {
      judge.current_head_judge_certificates.count
    }.from(0).to(1)
    .and not_change {
      judge.current_certified_judge_certificates.count
    }.and not_change {
      judge.current_general_judge_certificates.count
    }

    expect(page).to have_css(".judge-certificate")
    expect(page).to have_link(
      "View #{judge.seasons.last} certificate",
      href: judge.current_head_judge_certificates.last.file_url
    )
  end

  scenario "judge with 10 or more completed current scores" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, number_of_scores: 11)

    SeasonToggles.set_judging_round(:off)

    expect {
      sign_in(:admin)

      click_link "Participants"

      within_results_page_with("#account_#{judge.account_id}") do
        click_link "view"
      end
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

    expect(page).to have_css(".judge-certificate")
    expect(page).to have_link(
      "View #{judge.seasons.last} certificate",
      href: judge.current_judge_advisor_certificates.last.file_url
    )
  end

  scenario "RPE judges get a head judge certificate" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, :attending_live_event)

    SeasonToggles.set_judging_round(:off)

    expect {
      sign_in(:admin)

      click_link "Participants"

      within_results_page_with("#account_#{judge.account_id}") do
        click_link "view"
      end
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

    expect(page).to have_css(".judge-certificate")
    expect(page).to have_link(
      "View #{judge.seasons.last} certificate",
      href: judge.current_head_judge_certificates.last.file_url
    )
  end

  scenario "RPE judges with more than 10 scores get a judge advisor certificate" do
    SeasonToggles.set_judging_round(:sf)

    judge = FactoryBot.create(:judge, :onboarded, :attending_live_event, number_of_scores: 11)

    SeasonToggles.set_judging_round(:off)

    expect {
      sign_in(:admin)

      click_link "Participants"

      within_results_page_with("#account_#{judge.account_id}") do
        click_link "view"
      end
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

    expect(page).to have_css(".judge-certificate")
    expect(page).to have_link(
      "View #{judge.seasons.last} certificate",
      href: judge.current_judge_advisor_certificates.last.file_url
    )
  end
end