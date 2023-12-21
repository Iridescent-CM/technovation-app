require "rails_helper"

RSpec.feature "starting scores", js: true do
  before(:all) do
    @wait_time = Capybara.default_max_wait_time
    Capybara.default_max_wait_time = 15
  end

  after(:all) do
    Capybara.default_max_wait_time = @wait_time
  end

  context "as a virtual judge" do
    before do
      SeasonToggles.judging_round = :qf
    end

    after do
      SeasonToggles.judging_round = :off
    end

    scenario "starting a new score" do
      given_there_is_a_judge
      and_a_submission_that_needs_scoring

      and_the_judge_logs_in
      they_will_see_welcome_text_on_their_dashboard

      when_the_judge_starts_a_new_score
      then_they_see_the_overview_for_that_submission
    end

    scenario "unable to start new score with a score in progress" do
      given_there_is_a_judge
      and_a_submission_that_needs_scoring
      and_the_judge_has_a_score_in_progress_for_the_submission

      and_the_judge_logs_in
      then_they_will_not_see_a_way_to_start_a_new_virtual_score

      when_the_judge_views_their_judge_submissions_tab
      then_they_will_not_see_a_way_to_start_a_new_virtual_score
    end

    scenario "continuing with an unfinished score" do
      given_there_is_a_judge
      and_a_submission_that_needs_scoring
      and_the_judge_has_a_score_in_progress_for_the_submission

      and_the_judge_logs_in
      they_will_see_helper_text_on_their_dashboard

      when_the_judge_views_their_judge_submissions_tab
      and_resumes_scoring
      then_they_see_the_overview_for_that_submission
    end

    scenario "reviewing a completed score" do
      given_there_is_a_judge
      and_a_submission_that_needs_scoring
      and_the_judge_has_a_completed_score_for_the_submission

      and_the_judge_logs_in
      when_the_judge_views_their_judge_submissions_tab
      then_they_will_see_a_way_to_start_a_new_virtual_score

      when_the_judge_views_the_completed_score
      then_they_see_the_overview_for_that_submission
    end

    scenario "exceeding the maximum number of recusals" do
      given_there_is_a_judge
      and_the_judge_has_too_many_recusals
      and_a_submission_that_needs_scoring

      and_the_judge_logs_in
      they_will_see_welcome_text_on_their_dashboard

      when_the_judge_starts_a_new_score
      and_the_judge_clicks_the_recusal_button
      then_they_see_a_message_indicating_they_have_exceeded_the_maxiumum
    end
  end

  private

  def given_there_is_a_judge
    @judge = FactoryBot.create(:judge, :onboarded, :virtual)
  end

  def and_the_judge_has_too_many_recusals
    @judge.update_attribute(:recusal_scores_count, 100)
    @judge.reload
  end

  def and_the_judge_logs_in
    sign_in(@judge)
  end

  def and_a_submission_that_needs_scoring
    @submission = FactoryBot.create(:team_submission,
      :junior,
      :complete)
  end

  def and_the_judge_has_a_score_in_progress_for_the_submission
    score = FactoryBot.create(:score,
      :in_progress,
      :quarterfinals,
      judge_profile: @judge,
      team_submission: @submission)
  end

  def and_the_judge_has_a_completed_score_for_the_submission
    score = FactoryBot.create(:score,
      :complete,
      :quarterfinals,
      judge_profile: @judge,
      team_submission: @submission)
  end

  def when_the_judge_views_their_judge_submissions_tab
    click_link "Judge Submissions"
    expect(page).to have_content "Judging Rubric"
  end

  def when_the_judge_starts_a_new_score
    expect(page).to have_content "Start a new score"
    click_link "Start a new score"
  end

  def and_resumes_scoring
    click_link "Resume"
  end

  def and_the_judge_clicks_the_recusal_button
    expect(page).to have_content "I cannot judge this submission"
    click_link "I cannot judge this submission"
  end

  def when_the_judge_views_the_completed_score
    within "#finished-scores" do
      first(:link, "Review").click
    end
  end

  def and_starts_scoring_the_submission
    click_link "Start"
  end

  def they_will_see_welcome_text_on_their_dashboard
    expect(page).to have_content("Welcome to the online judging portal for the first round of Technovation Judging!")
  end

  def they_will_see_helper_text_on_their_dashboard
    expect(page).to have_content "View the submissions tab to continue scoring."
  end

  def then_they_see_the_overview_for_that_submission
    expect(page).to have_content(@submission.team_name)
    expect(page).to have_content("#{@submission.team.division_name.upcase} DIVISION")
    expect(page).to have_link "Start Score"
  end

  def then_they_will_not_see_a_way_to_start_a_new_virtual_score
    expect(page).not_to have_link "Start a new score"
  end

  def then_they_will_see_a_way_to_start_a_new_virtual_score
    expect(page).to have_link "Start a new score"
  end

  def then_they_see_a_message_indicating_they_have_exceeded_the_maxiumum
    expect(page).to have_content(/A judge may only recuse themselves from \d+ submissions/)
  end
end
