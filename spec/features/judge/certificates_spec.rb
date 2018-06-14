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
end