require "rails_helper"

RSpec.feature "Student submits a project", :js do

  before { SeasonToggles.team_submissions_editable! }

  scenario "unable to submit prior to completing the submission" do
    submission = FactoryBot.create(:submission, :complete, :junior)
    submission.update(published_at: nil)
    submission.update(app_name: '')

    student = submission.team.students.sample

    sign_in(student)

    click_link "Your app's name"

    expect(page).to have_link "Submit for judging", class: "button--disabled"
  end

  scenario "completing and submitting the submission" do
    submission = FactoryBot.create(:submission, :complete, :junior)
    submission.update(published_at: nil)
    submission.update(app_name: '')

    student = submission.team.students.sample

    sign_in(student)

    click_link "Your app's name"

    fill_in "Your app's name", with: "Coolest app"
    click_button "Save this name"

    click_link "Review and submit"

    click_link "Submit now"

    click_link "We agree"

    expect(page).to have_content "Your submission has been entered for judging!"
    expect(page).to have_link "View your complete submission"
    expect(submission.reload).to be_published
  end

  scenario "submitting a completed submission from the dashboard" do
    submission = FactoryBot.create(:submission, :complete, :junior)
    submission.update(published_at: nil)

    student = submission.team.students.sample

    sign_in(student)

    click_link "Review and submit now!"

    click_link "Submit now"

    click_link "We agree"

    expect(page).to have_content "Your submission has been entered for judging!"
    expect(page).to have_link "View your complete submission"
    expect(submission.reload).to be_published
  end
end