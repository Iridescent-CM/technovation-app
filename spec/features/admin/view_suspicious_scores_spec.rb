require "rails_helper"

RSpec.feature "Admins viewing suspicious scores", js: true do
  let(:admin) { FactoryBot.create(:admin) }

  scenario "scores that are too low are displayed on the Scores page" do
    FactoryBot.create(:score, :score_too_low)

    sign_in(admin)
    click_link "Scores"

    within ".suspicious-scores" do
      expect(page).to have_content("SEEMS TOO LOW")
    end
  end

  scenario "scores that are completed too fast by repeat offenders are displayed on the Scores page" do
    FactoryBot.create(:score, :score_completed_too_fast_by_repeat_offender)

    sign_in(admin)
    click_link "Scores"

    within ".suspicious-scores" do
      expect(page).to have_content("COMPLETED TOO FAST")
    end
  end

  scenario "scores that are too low and completed too fast by repeat offenders are displayed on the Scores page" do
    FactoryBot.create(:score, :score_too_low, :score_too_low_and_completed_too_fast_by_repeat_offender)

    sign_in(admin)
    click_link "Scores"

    within ".suspicious-scores" do
      expect(page).to have_content("SEEMS TOO LOW AND COMPLETED TOO FAST")
    end
  end

  scenario "no suspicious scores" do
    sign_in(admin)
    click_link "Scores"

    within ".suspicious-scores" do
      expect(page).to have_content("There are no suspicious scores at this time.")
    end
  end
end
