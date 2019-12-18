require "rails_helper"

RSpec.feature "Admins view scores" do
  scenario "view QF scores" do
    submission = FactoryBot.create(
      :submission,
      :junior,
      :complete,
    )

    FactoryBot.create(
      :submission_score,
      :complete,
      team_submission: submission
    )

    SeasonToggles.judging_round = :qf
    admin = FactoryBot.create(:admin)
    sign_in(admin)

    visit admin_scores_path
    find("a.view-details").click

    expect(page).to have_content("View score")
  end

  scenario "view SF scores" do
    submission = FactoryBot.create(
      :submission,
      :junior,
      :complete,
      :semifinalist,
    )

    FactoryBot.create(
      :score,
      :complete,
      :semifinals,
      team_submission: submission
    )

    SeasonToggles.judging_round = :sf
    admin = FactoryBot.create(:admin)
    sign_in(admin)

    visit admin_scores_path
    find("a.view-details").click

    expect(page).to have_content("View score")
  end
end
