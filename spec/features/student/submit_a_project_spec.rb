require "rails_helper"

RSpec.feature "Student submits a project", :js do

  before { SeasonToggles.team_submissions_editable! }

  scenario "unable to submit prior to completing the submission" do
    given_there_is_a_team_with_an_incomplete_submission
    that_hasnt_been_submitted
    and_a_student_from_that_team_is_logged_in

    when_they_view_their_submission
    then_they_see_a_disabled_submit_button
  end

  scenario "completing and submitting the submission" do
    given_there_is_a_team_with_an_incomplete_submission
    that_hasnt_been_submitted
    and_a_student_from_that_team_is_logged_in

    when_they_complete_their_submission
    and_review_it
    and_submit_it

    then_they_see_that_their_app_will_be_judged
    and_it_is_marked_as_published
  end

  scenario "submitting a completed submission from the dashboard" do
    given_there_is_a_team_with_a_complete_submission
    that_hasnt_been_submitted
    and_a_student_from_that_team_is_logged_in

    when_they_review_it_from_the_dashboard
    and_submit_it

    then_they_see_that_their_app_will_be_judged
    and_it_is_marked_as_published
  end

  def given_there_is_a_team_with_an_incomplete_submission
    @submission = FactoryBot.create(:submission, :complete, :junior)
    @submission.update(app_name: '')
  end

  def given_there_is_a_team_with_a_complete_submission
    @submission = FactoryBot.create(:submission, :complete, :junior)
  end

  def that_hasnt_been_submitted
    @submission.update(published_at: nil)
  end

  def and_a_student_from_that_team_is_logged_in
    student = @submission.team.students.sample

    sign_in(student)
  end

  def when_they_view_their_submission
    click_link "My team's submission"
  end

  def then_they_see_a_disabled_submit_button
    expect(page).to have_link "Submit for judging", class: "button--disabled"
  end

  def when_they_complete_their_submission
    click_link "Your app's name"
    fill_in "Your app's name", with: "Coolest app"
    click_button "Save this name"
  end

  def and_review_it
    click_link "Review and submit"
  end

  def and_submit_it
    click_link "Submit now"
    click_link "We agree"
  end

  def when_they_review_it_from_the_dashboard
    click_link "Review and submit now!"
  end

  def then_they_see_that_their_app_will_be_judged
    expect(page).to have_content "Your submission has been entered for judging!"
  end

  def and_it_is_marked_as_published
    expect(@submission.reload).to be_published
  end
end