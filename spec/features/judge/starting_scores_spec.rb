require "rails_helper"

feature "starting scores", js: true do

  context "as an RPE judge" do
    before do
      SeasonToggles.judging_round = :qf
    end

    after do
      SeasonToggles.judging_round = :off
    end

    scenario "TBD"
  end

  context "as a virtual judge" do
    before do
      SeasonToggles.judging_round = :qf
    end

    after do
      SeasonToggles.judging_round = :off
    end

    scenario "starting a new score" do
      given_there_is_a_submission_from_a_junior_team_that_needs_scoring
      and_a_user_is_logged_in_as_a_judge

      when_the_judge_views_their_dashboard
      and_starts_a_new_score

      then_they_see_the_scoring_screens_for_that_submission
    end

    scenario "unable to start new score with a score in progress" do
      given_there_is_a_submission_assigned_to_a_judge
      and_that_judge_is_logged_in

      when_the_judge_views_their_dashboard

      then_they_will_not_see_a_way_to_start_a_new_score
    end

    scenario "continuing with an unfinished score" do
      given_there_is_a_submission_assigned_to_a_judge
      and_that_judge_is_logged_in

      when_the_judge_views_their_dashboard
      and_resumes_scoring

      then_they_see_the_scoring_screens_for_that_submission
    end

    scenario "reviewing a completed score" do
      given_there_is_a_judge_with_a_completed_score
      and_that_judge_is_logged_in

      when_the_judge_views_their_dashboard
      and_navigates_to_their_finished_scores
      and_reviews_their_completed_score

      then_they_see_the_scoring_screens_for_that_submission
    end
  end

  private

  def given_there_is_a_submission_from_a_junior_team_that_needs_scoring
    @submission = FactoryBot.create(:team_submission, :junior, :complete)
  end

  def and_a_user_is_logged_in_as_a_judge
    judge = FactoryBot.create(:judge, :onboarded)

    sign_in(judge)
  end

  def given_there_is_a_submission_assigned_to_a_judge
    @judge = FactoryBot.create(:judge, :onboarded)
    score = FactoryBot.create(:score, :incomplete, :quarterfinals, judge_profile: @judge)
    @submission = score.team_submission
  end

  def and_that_judge_is_logged_in
    sign_in(@judge)
  end

  def given_there_is_a_judge_with_a_completed_score
    @judge = FactoryBot.create(:judge, :onboarded)
    score = FactoryBot.create(:score, :complete, :quarterfinals, judge_profile: @judge)
    @submission = score.team_submission
  end

  def when_the_judge_views_their_dashboard
    click_link "My Dashboard"
    expect(page).to have_content "Judge Dashboard"
  end

  def and_starts_a_new_score
    click_link "Start a new score"
  end

  def and_resumes_scoring
    click_link "Resume"
  end

  def and_navigates_to_their_finished_scores
    click_link "Finished scores"
  end

  def and_reviews_their_completed_score
    click_link "Review"
  end

  def then_they_see_the_scoring_screens_for_that_submission
    expect(page).to have_content(@submission.team_name)
    expect(page).to have_content(@submission.app_name)
    expect(page).to have_link "Start scoring"
  end

  def then_they_will_not_see_a_way_to_start_a_new_score
    expect(page).not_to have_link "Start a new score"
  end

  def and_they_will_see_a_link_to_resume_scoring
    within ".score-in-progress" do
      expect(page).to have_content(@submission.team_name)
      expect(page).to have_content(@submission.app_name)
      expect(page).to have_link "Resume"
    end
  end
end