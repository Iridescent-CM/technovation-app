require "rails_helper"

feature "starting scores", js: true do

  before(:all) do
    @wait_time = Capybara.default_max_wait_time
    Capybara.default_max_wait_time = 15
  end

  after(:all) do
    Capybara.default_max_wait_time = @wait_time
  end

  context "as an RPE judge" do
    before do
      SeasonToggles.judging_round = :qf
    end

    after do
      SeasonToggles.judging_round = :off
    end

    scenario "no button to score virtual submissions" do
      given_there_is_a_logged_in_judge
      and_they_are_assigned_to_an_RPE

      when_the_judge_views_their_dashboard

      then_they_will_not_see_a_way_to_start_a_new_virtual_score
    end

    scenario "able to start scoring an assigned submission" do
      given_there_is_a_logged_in_judge
      and_they_are_assigned_to_an_RPE
      and_the_RPE_has_a_submission

      when_the_judge_views_their_dashboard
      and_starts_scoring_the_submission
      then_they_see_the_scoring_screens_for_that_submission
    end

    scenario "see start buttons for all assigned submissions" do
      given_there_is_a_logged_in_judge
      and_they_are_assigned_to_an_RPE
      and_the_RPE_has_several_submissions

      when_the_judge_views_their_dashboard

      then_they_see_start_buttons_for_all_assigned_submissions
    end

    scenario "able to resume scoring an assigned submission" do
      given_there_is_a_logged_in_judge
      and_they_are_assigned_to_an_RPE
      and_the_RPE_has_a_submission
      and_the_judge_has_a_score_in_progress_for_the_submission

      when_the_judge_views_their_dashboard
      and_resumes_scoring_from_the_score_management_panel

      then_they_see_the_scoring_screens_for_that_submission
    end

    scenario "able to review completed score for an assigned submission" do
      given_there_is_a_logged_in_judge
      and_they_are_assigned_to_an_RPE
      and_the_RPE_has_a_submission
      and_the_judge_has_a_completed_score_for_the_submission

      when_the_judge_views_their_dashboard
      and_views_the_completed_score

      then_they_see_the_scoring_screens_for_that_submission
    end
  end

  context "as a virtual judge" do
    before do
      SeasonToggles.judging_round = :qf
    end

    after do
      SeasonToggles.judging_round = :off
    end

    scenario "starting a new score" do
      given_there_is_a_logged_in_judge
      and_a_submission_that_needs_scoring

      when_the_judge_views_their_dashboard
      and_starts_a_new_score

      then_they_see_the_scoring_screens_for_that_submission
    end

    scenario "unable to start new score with a score in progress" do
      given_there_is_a_logged_in_judge
      and_a_submission_that_needs_scoring
      and_the_judge_has_a_score_in_progress_for_the_submission

      when_the_judge_views_their_dashboard

      then_they_will_not_see_a_way_to_start_a_new_virtual_score
    end

    scenario "continuing with an unfinished score" do
      given_there_is_a_logged_in_judge
      and_a_submission_that_needs_scoring
      and_the_judge_has_a_score_in_progress_for_the_submission

      when_the_judge_views_their_dashboard
      and_resumes_scoring

      then_they_see_the_scoring_screens_for_that_submission
    end

    scenario "reviewing a completed score" do
      given_there_is_a_logged_in_judge
      and_a_submission_that_needs_scoring
      and_the_judge_has_a_completed_score_for_the_submission

      when_the_judge_views_their_dashboard
      and_views_the_completed_score

      then_they_see_the_scoring_screens_for_that_submission
    end
  end

  private

  def given_there_is_a_logged_in_judge
    @judge = FactoryBot.create(:judge,
      :onboarded
    )
    sign_in(@judge)
  end

  def and_a_submission_that_needs_scoring
    @submission = FactoryBot.create(:team_submission,
      :junior,
      :complete
    )
  end

  def and_the_judge_has_a_score_in_progress_for_the_submission
    score = FactoryBot.create(:score,
      :incomplete,
      :quarterfinals,
      judge_profile: @judge,
      team_submission: @submission
    )
  end

  def and_the_judge_has_a_completed_score_for_the_submission
    score = FactoryBot.create(:score,
      :complete,
      :quarterfinals,
      judge_profile: @judge,
      team_submission: @submission
    )
  end

  def and_they_are_assigned_to_an_RPE
    @rpe = FactoryBot.create(:rpe)
    @judge.regional_pitch_events << @rpe
  end

  def and_the_RPE_has_a_submission
    @submission = FactoryBot.create(:team_submission, :junior, :complete)
    @submission.team.regional_pitch_events << @rpe
  end

  def and_the_RPE_has_several_submissions
    @submissions = FactoryBot.create_list(:team_submission, 3, :junior, :complete)
    @submissions.each do |sub|
      sub.team.regional_pitch_events << @rpe
    end
  end

  def when_the_judge_views_their_dashboard
    click_link "My Dashboard"
    expect(page).to have_content "Judge Dashboard"
  end

  def and_starts_a_new_score
    expect(page).to have_content "Start a new score"
    click_link "Start a new score"
  end

  def and_resumes_scoring
    click_link "Resume"
  end

  def and_resumes_scoring_from_the_score_management_panel
    within ".score-in-progress + .panel" do
      click_link "Resume"
    end
  end

  def and_views_the_completed_score
    within "#finished-scores" do
      first(:link, "Review").click
    end
  end

  def and_starts_scoring_the_submission
    click_link "Start"
  end

  def then_they_see_the_scoring_screens_for_that_submission
    expect(page).to have_content("Review submission")
    expect(page).to have_content(@submission.team_name)
    expect(page).to have_content(@submission.app_name)
  end

  def then_they_will_not_see_a_way_to_start_a_new_virtual_score
    expect(page).not_to have_link "Start a new score"
  end

  def then_they_see_start_buttons_for_all_assigned_submissions
    expect(page).to have_link "Start", count: @submissions.count
  end
end
