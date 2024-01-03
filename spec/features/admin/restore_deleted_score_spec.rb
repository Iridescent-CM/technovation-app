require "rails_helper"

RSpec.describe "Admins restoring a deleted score", type: :feature do
  scenario "restoring a deleted score" do
    given_an_admin_is_logged_in
    and_there_is_a_deleted_score

    when_the_admin_views_the_deleted_score
    and_clicks_the_restore_score_button

    then_the_score_is_restored
  end

  private

  def given_an_admin_is_logged_in
    admin = FactoryBot.create(:admin)

    sign_in(admin)
  end

  def and_there_is_a_deleted_score
    submission_score = SubmissionScore.create!(
      judge_profile_id: FactoryBot.create(:judge).id,
      team_submission_id: FactoryBot.create(:submission, :complete).id,
      ideation_1: 20,
      round: "quarterfinals",
      completed_at: Time.current
    )

    submission_score.delete
  end

  def when_the_admin_views_the_deleted_score
    visit admin_score_exports_path

    select "Quarterfinals", from: "scores_grid[round]", visible: false
    select "Include deleted scores", from: "scores_grid[deleted]", visible: false
    click_button("Search")

    find("tbody tr td.view .view-details").click
  end

  def and_clicks_the_restore_score_button
    click_button("Restore this score")
  end

  def then_the_score_is_restored
    expect(SubmissionScore.all.length).to eq(1)
    expect(SubmissionScore.last).not_to be_deleted

    expect(page).to have_content("This score has been restored")
  end
end
