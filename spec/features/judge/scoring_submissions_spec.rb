require "rails_helper"

RSpec.feature "scoring submissions", js: true do
  before do
    SeasonToggles.judging_round = :qf
  end

  after do
    SeasonToggles.judging_round = :off
  end

  scenario "when a beginner team receives a perfect score" do
    given_there_is_a_submission_from_a_beginner_team_that_needs_scoring
    and_a_judge_is_logged_in

    when_the_judge_starts_a_new_scoring_session
    and_scores_the_project_details_section_perfectly
    and_scores_the_pitch_section_perfectly
    and_scores_the_technical_section_perfectly
    and_scores_the_ideation_section_perfectly

    then_the_review_page_displays_a_perfect_score_of 39
    and_then_submits_the_score
  end

  scenario "when a junior team receives a perfect score" do
    given_there_is_a_submission_from_a_junior_team_that_needs_scoring
    and_a_judge_is_logged_in

    when_the_judge_starts_a_new_scoring_session
    and_scores_the_project_details_section_perfectly
    and_scores_the_pitch_section_perfectly
    and_scores_the_technical_section_perfectly
    and_scores_the_entrepreneurship_section_perfectly
    and_scores_the_ideation_section_perfectly

    then_the_review_page_displays_a_perfect_score_of 80
    and_then_submits_the_score
  end

  scenario "when a senior team receives a perfect score" do
    given_there_is_a_submission_from_a_senior_team_that_needs_scoring
    and_a_judge_is_logged_in

    when_the_judge_starts_a_new_scoring_session
    and_scores_the_project_details_section_perfectly
    and_scores_the_pitch_section_perfectly
    and_scores_the_technical_section_perfectly
    and_scores_the_entrepreneurship_section_perfectly
    and_scores_the_ideation_section_perfectly

    then_the_review_page_displays_a_perfect_score_of 90
    and_then_submits_the_score
  end

  private

  def given_there_is_a_submission_from_a_beginner_team_that_needs_scoring
    @submission = FactoryBot.create(:team_submission, :beginner, :complete)
  end

  def given_there_is_a_submission_from_a_junior_team_that_needs_scoring
    @submission = FactoryBot.create(:team_submission, :junior, :complete)
  end

  def given_there_is_a_submission_from_a_senior_team_that_needs_scoring
    @submission = FactoryBot.create(:team_submission, :senior, :complete)
  end

  def and_a_judge_is_logged_in
    judge = FactoryBot.create(:judge, :onboarded)
    sign_in(judge)
  end

  def when_the_judge_starts_a_new_scoring_session
    click_link("Start a new score")
    click_link("Start Score")
  end

  def and_scores_the_project_details_section_perfectly
    click_highest_score_bubble
    fill_in_comment
  end

  def and_scores_the_pitch_section_perfectly
    click_next_button("Next")

    click_highest_score_bubble
    fill_in_comment
  end

  def and_scores_the_technical_section_perfectly
    click_next_button("Next")

    click_highest_score_bubble
    fill_in_comment
  end

  def and_scores_the_entrepreneurship_section_perfectly
    click_next_button("Next")

    click_highest_score_bubble
    fill_in_comment
  end

  def and_scores_the_ideation_section_perfectly
    # this is the learning journey section
    click_next_button("Next")

    click_highest_score_bubble
    fill_in_comment
  end

  def then_the_review_page_displays_a_perfect_score_of(perfect_score)
    click_next_button("Next")

    expect(page).to have_content("Total Score")
    expect(page).to have_content("#{perfect_score}")
  end

  def and_then_submits_the_score
    finish_score_button = find("#judge-scores-app a.link-button", text: "Finish Score")

    execute_script("arguments[0].click();", finish_score_button)
  end

  def click_next_button(button_text)
    next_button = find("#judge-scores-app a.link-button", text: button_text)

    execute_script("arguments[0].click();", next_button)
  end

  def click_highest_score_bubble
    highest_score = @submission.beginner_division? ? "3" : "5"
    highest_score_bubble = all("#judge-scores-app li.score-value", text: "#{highest_score}")
    highest_score_bubble.each(&:click)
  end

  def fill_in_comment
    find("#judge-scores-app textarea").set("Lorem ipsum dolor sit amet consectetur adipiscing elit iaculis suspendisse natoque magna senectus, tempus nulla maecenas rutrum cursus euismod ante cras posuere proin himenaeos. Nisi primis ullamcorper penatibus vivamus dapibus, risus vel lobortis nam sed convallis, velit a cubilia hendrerit.")
  end
end
