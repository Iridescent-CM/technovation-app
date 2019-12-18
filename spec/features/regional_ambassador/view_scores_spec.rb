require "rails_helper"

RSpec.feature "Regional Ambassador views scores" do
  before do
    ra = FactoryBot.create(:regional_ambassador, :approved)
    sign_in(ra)
  end

  context "after scores set to display" do

    before do
      SeasonToggles.display_scores_on!
    end

    scenario "RA can't pick finals scores, as there is no such thing" do
      click_link "Scores"
      options = page.find("[name='scored_submissions_grid[round]']").all('option')
      expect(options.map(&:value)).not_to include("finals")
    end

    scenario "can view virtual QF scores" do
      submission = FactoryBot.create(
        :submission,
        :complete,
      )

      FactoryBot.create(:submission_score, :complete, team_submission: submission)

      click_link "Scores"
      within_results_page_with("#team_submission_#{submission.id}") do
        find('a.view-details').click
      end

      expect(page).to have_content("View score")
    end

    scenario "can view SF scores" do
      submission = FactoryBot.create(
        :submission,
        :complete,
        :semifinalist,
      )

      FactoryBot.create(
        :score,
        :complete,
        round: :semifinals,
        team_submission: submission
      )

      visit regional_ambassador_scores_path(scored_submissions_grid: { round: :semifinals })
      within_results_page_with("#team_submission_#{submission.id}") do
        find('a.view-details').click
      end

      expect(page).to have_content("View score")
    end

    scenario "can see SF columns and data" do
      submission = FactoryBot.create(
        :submission,
        :complete,
        :semifinalist,
      )

      FactoryBot.create(:submission_score, :complete, team_submission: submission)
      FactoryBot.create(
        :score,
        :complete,
        round: :semifinals,
        team_submission: submission
      )

      click_link "Scores"

      expect(page).to have_selector(".semifinals_average")

      within_results_page_with("#team_submission_#{submission.id}") do
        find('a.view-details').click
      end

      expect(page).to have_content("Semifinals average")
    end
  end

  context "before scores set to display" do

    before do
      SeasonToggles.display_scores_off!
    end

    scenario "can view live QF scores" do
      submission = FactoryBot.create(
        :submission,
        :complete,
      )

      FactoryBot.create(:submission_score, :complete, team_submission: submission)

      rpe = FactoryBot.create(:rpe)

      rpe.teams << submission.team

      click_link "Scores"
      within_results_page_with("#team_submission_#{submission.id}") do
        find('a.view-details').click
      end

      expect(page).to have_content("View score")
    end

    scenario "can not view virtual QF scores" do
      submission = FactoryBot.create(
        :submission,
        :complete,
      )

      FactoryBot.create(:submission_score, :complete, team_submission: submission)

      click_link "Scores"
      expect(page).to have_no_selector("#team_submission_#{submission.id}")
      expect(page).to have_no_selector(".next_page")
    end

    scenario "can not see SF columns and data" do
      submission = FactoryBot.create(
        :submission,
        :complete,
        :semifinalist,
      )

      rpe = FactoryBot.create(:rpe)

      rpe.teams << submission.team

      FactoryBot.create(:submission_score, :complete, team_submission: submission)
      FactoryBot.create(
        :score,
        :complete,
        round: :semifinals,
        team_submission: submission
      )

      click_link "Scores"

      expect(page).to have_no_selector(".semifinals_average")

      within_results_page_with("#team_submission_#{submission.id}") do
        find('a.view-details').click
      end

      expect(page).not_to have_content("Semifinals average")
    end
  end
end
