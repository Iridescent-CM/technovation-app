require "rails_helper"

xfeature "scoring submissions", js: true do
  before do
    SeasonToggles.judging_round = :qf
  end

  after do
    SeasonToggles.judging_round = :off
  end

  scenario "when a junior team receives a perfect score" do
    given_there_is_a_submission_from_a_junior_team_that_needs_scoring
    and_a_judge_is_logged_in

    when_the_judge_starts_a_new_scoring_session
    and_scores_the_ideation_section_perfectly
    and_scores_the_technical_section_perfectly
    and_scores_the_pitch_section_perfectly
    and_scores_the_overall_section_perfectly
    and_submits_the_score

    then_the_review_page_displays_a_perfect_score_of 60
  end

  scenario "when a senior team receives a perfect score" do
    given_there_is_a_submission_from_a_senior_team_that_needs_scoring
    and_a_judge_is_logged_in

    when_the_judge_starts_a_new_scoring_session
    and_scores_the_ideation_section_perfectly
    and_scores_the_technical_section_perfectly
    and_scores_the_pitch_section_perfectly
    and_scores_the_entrepreneurship_section_perfectly
    and_scores_the_overall_section_perfectly
    and_submits_the_score

    then_the_review_page_displays_a_perfect_score_of 80
  end

  private

  def given_there_is_a_submission_from_a_junior_team_that_needs_scoring
    FactoryBot.create(:team_submission, :junior, :complete)
  end

  def given_there_is_a_submission_from_a_senior_team_that_needs_scoring
    FactoryBot.create(:team_submission, :senior, :complete)
  end

  def and_a_judge_is_logged_in
    judge = FactoryBot.create(:judge, :onboarded)
    sign_in(judge)
  end

  def when_the_judge_starts_a_new_scoring_session
    click_link("Start a new score")
    click_link("Start scoring")
  end

  def and_scores_the_ideation_section_perfectly
    find("#judge-scores-app li.score-question:nth-child(1) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(2) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(3) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(4) li.score-value", text: "5").click
    find("#judge-scores-app textarea").set("Lorem ipsum dolor sit amet consectetur adipiscing elit iaculis suspendisse natoque magna senectus, tempus nulla maecenas rutrum cursus euismod ante cras posuere proin himenaeos. Nisi primis ullamcorper penatibus vivamus dapibus, risus vel lobortis nam sed convallis, velit a cubilia hendrerit.")

    # expect(page).to have_content("Ideation\n20 / 20")
  end

  def and_scores_the_technical_section_perfectly
    click_next_button("Next: Technical")

    find("#judge-scores-app li.score-question:nth-child(1) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(2) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(3) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(4) li.score-value", text: "5").click
    find("#judge-scores-app textarea").set("Lorem ipsum dolor sit amet consectetur adipiscing elit iaculis suspendisse natoque magna senectus, tempus nulla maecenas rutrum cursus euismod ante cras posuere proin himenaeos. Nisi primis ullamcorper penatibus vivamus dapibus, risus vel lobortis nam sed convallis, velit a cubilia hendrerit.")

    # expect(page).to have_content("Technical\n20 / 20")
  end

  def and_scores_the_pitch_section_perfectly
    click_next_button("Next: Pitch")

    find("#judge-scores-app li.score-question:nth-child(1) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(2) li.score-value", text: "5").click
    find("#judge-scores-app textarea").set("Lorem ipsum dolor sit amet consectetur adipiscing elit iaculis suspendisse natoque magna senectus, tempus nulla maecenas rutrum cursus euismod ante cras posuere proin himenaeos. Nisi primis ullamcorper penatibus vivamus dapibus, risus vel lobortis nam sed convallis, velit a cubilia hendrerit.")

    # expect(page).to have_content("Pitch\n10 / 10")
  end

  def and_scores_the_entrepreneurship_section_perfectly
    click_next_button("Next: Entrepreneurship")

    find("#judge-scores-app li.score-question:nth-child(1) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(2) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(3) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(4) li.score-value", text: "5").click
    find("#judge-scores-app textarea").set("Lorem ipsum dolor sit amet consectetur adipiscing elit iaculis suspendisse natoque magna senectus, tempus nulla maecenas rutrum cursus euismod ante cras posuere proin himenaeos. Nisi primis ullamcorper penatibus vivamus dapibus, risus vel lobortis nam sed convallis, velit a cubilia hendrerit.")

    # expect(page).to have_content("Entrepreneurship\n20 / 20")
  end

  def and_scores_the_overall_section_perfectly
    click_next_button("Next: Overall")

    find("#judge-scores-app li.score-question:nth-child(1) li.score-value", text: "5").click
    find("#judge-scores-app li.score-question:nth-child(2) li.score-value", text: "5").click
    find("#judge-scores-app textarea").set("Lorem ipsum dolor sit amet consectetur adipiscing elit iaculis suspendisse natoque magna senectus, tempus nulla maecenas rutrum cursus euismod ante cras posuere proin himenaeos. Nisi primis ullamcorper penatibus vivamus dapibus, risus vel lobortis nam sed convallis, velit a cubilia hendrerit.")

    # expect(page).to have_content("Overall Impression\n10 / 10")

    click_next_button("Next: Review score")
  end

  def and_submits_the_score
    finish_score_button = find("#judge-scores-app a.button", text: "Finish score")

    execute_script("arguments[0].click();", finish_score_button)
  end

  def then_the_review_page_displays_a_perfect_score_of(perfect_score)
    click_link("review your score")

    # expect(page).to have_content("#{perfect_score} / #{perfect_score}")
  end

  def click_next_button(button_text)
    next_button = find("#judge-scores-app a.button.btn-next", text: button_text)

    execute_script("arguments[0].click();", next_button)
  end
end
