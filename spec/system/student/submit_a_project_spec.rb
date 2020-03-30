require "rails_helper"

RSpec.feature "Student submits a project", :js do

  before { SeasonToggles.team_submissions_editable! }

  scenario "completing a submission" do
    submission = FactoryBot.create(:submission, :complete, :junior)
    submission.update(published_at: nil)
    submission.update(app_name: '')

    student = submission.team.students.sample

    sign_in(student)
    expect(page).to have_link "Your app's name"

    click_link "Your app's name"
    expect(page).to have_content "App name"

    expect(page).to have_link "Submit for judging", class: "button--disabled"

    fill_in "Your app's name", with: "Coolest app"
    click_button "Save this name"
    expect(page).to have_content "Your progress has been saved"

    expect(page).to have_link "Review and submit"

    click_link "Review and submit"
    expect(page).to have_link "Submit now"
  end

  scenario "submitting a complete, unpublished submission" do
    submission = FactoryBot.create(:submission, :complete, :junior)
    submission.update(published_at: nil)

    student = submission.team.students.sample

    sign_in(student)
    expect(page).to have_link "Review and submit now!"

    click_link "Review and submit now!"
    expect(page).to have_link "Submit now"

    click_link "Submit now"
    expect(page).to have_text "#{Season.current.year} Technovation Honor Code"
    expect(page).to have_link "We agree"

    click_link "We agree"
    expect(page).to have_content "Your submission has been entered for judging!"
    expect(page).to have_link "View your complete submission"

    expect(submission.reload).to be_published
  end
end