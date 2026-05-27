require "rails_helper"

RSpec.feature "Admins view scores" do
  scenario "view QF scores" do
    submission = FactoryBot.create(
      :submission,
      :junior,
      :complete
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
      :semifinalist
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

  scenario "Admin has admin-only extra columns" do
    submission = FactoryBot.create(
      :submission,
      :junior,
      :complete
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

    expect(page).to have_select(
      "More columns",
      with_options: [
        "Team ID",
        "Submission ID"
      ]
    )
  end

  scenario "admin score drilldown shows full judge identity with participant link" do
    submission = FactoryBot.create(:submission, :junior, :complete)
    judge = FactoryBot.create(:judge_profile, first_name: "Mira")
    judge.account.update!(last_name: "Thompson")
    admin = FactoryBot.create(:admin)

    FactoryBot.create(
      :submission_score,
      :complete,
      team_submission: submission,
      judge_profile: judge
    )

    sign_in(admin)
    visit admin_scores_path

    find("a.view-details").click

    within "#complete-quarterfinal-scores" do
      expect(page).to have_link("Mira Thompson", href: admin_participant_path(judge.account_id))
      click_link "View score"
    end

    within ".admin-score-header" do
      expect(page).to have_link("Mira Thompson", href: admin_participant_path(judge.account_id))
      expect(page).to have_content(judge.email)
      expect(page).to have_content("Score comes from")
    end
  end
end
