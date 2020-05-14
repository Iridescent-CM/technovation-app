require "rails_helper"

RSpec.feature "Admin updates contest rank", js: true do
  scenario "setting a semifinalist" do
    given_there_is_a_scored_quarterfinalist_team
    and_a_logged_in_admin_viewing_scores

    when_they_are_marked_as_a_semifinalist

    then_a_confirmation_shows
    and_the_change_is_persisted
  end

  scenario "setting a finalist" do
    given_there_is_a_scored_semifinalist_team
    and_a_logged_in_admin_viewing_scores

    when_they_are_marked_as_a_finalist

    then_a_confirmation_shows
    and_the_change_is_persisted
  end

  def given_there_is_a_scored_quarterfinalist_team
    @submission = FactoryBot.create(
      :submission,
      :complete
    )
    FactoryBot.create(
      :score,
      :complete,
      team_submission: @submission,
      round: :quarterfinals
    )
  end

  def given_there_is_a_scored_semifinalist_team
    @submission = FactoryBot.create(
      :submission,
      :complete,
      contest_rank: "semifinalist"
    )
    FactoryBot.create(
      :score,
      :complete,
      team_submission: @submission,
      round: :quarterfinals
    )
    FactoryBot.create(
      :score,
      :complete,
      team_submission: @submission,
      round: :semifinals
    )
  end

  def and_a_logged_in_admin_viewing_scores
    admin = FactoryBot.create(:admin)
    sign_in(admin)
    visit admin_scores_path
  end

  def when_they_are_marked_as_a_semifinalist
    mark_as_a("semifinalist")
  end

  def when_they_are_marked_as_a_finalist
    mark_as_a("finalist")
  end

  def mark_as_a(rank)
    @new_rank = rank
    within("#team_submission_#{@submission.id}") do
      select @new_rank, from: "contest_rank"
    end
  end

  def then_a_confirmation_shows
    within("#flash") do
      expect(page).to have_content("#{@submission.team.name} has been marked as a #{@new_rank}")
    end
  end

  def and_the_change_is_persisted
    expect(@submission.reload.contest_rank).to eq(@new_rank)
  end
end