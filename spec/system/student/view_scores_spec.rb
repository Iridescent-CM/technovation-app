require "rails_helper"

RSpec.describe "Students view scores", :js do
  before do
    SeasonToggles.display_scores_on!
    SeasonToggles.set_survey_link(:student, "Hello World", "https://google.com")
  end

  it "Unfinished / unstarted submission" do
    submission = FactoryBot.create(:submission, :incomplete)

    sign_in(submission.team.students.sample)
    visit student_dashboard_path
    click_button "Find your scores & certificates"

    expect(page).to have_content("Thank you for your participation")
    expect(page).to have_content(
      "Unfortunately, no scores are available for your team " +
      "because your submission was incomplete"
    )
  end

  it "view QF scores if program survey completed" do
    submission = FactoryBot.create(
      :submission,
      :complete
    )

    FactoryBot.create(:submission_score, :complete, team_submission: submission)

    student = submission.team.students.sample
    student.account.took_program_survey!

    sign_in(student)
    click_button "Find your scores & certificates"
    click_link "View your scores and certificate"

    expect(page).to have_selector("#student-finished-scores-table")

    expect(page).to have_content("Scores Explained")
  end

  it "view SF scores if program survey is completed" do
    submission = FactoryBot.create(
      :submission,
      :complete,
      :semifinalist,
    )

    FactoryBot.create(
      :score,
      :complete,
      round: :semifinals,
      team_submission: submission
    )

    student = submission.team.students.sample
    student.account.took_program_survey!

    sign_in(student)
    click_button "Find your scores & certificates"
    click_link "View your scores and certificate"

    expect(page).to have_selector("#student-finished-scores-table")

    expect(page).to have_content("Scores Explained")
    end

  it "view QF scores page if program survey is not completed" do
    submission = FactoryBot.create(
      :submission,
      :complete
    )

    FactoryBot.create(
      :score,
      :complete,
      round: :semifinals,
      team_submission: submission
    )

    student = submission.team.students.sample
    sign_in(student)
    expect(page).to have_content("Before you can view your scores and certificates, please complete the post-survey.")
    expect(page).to have_selector(:link_or_button, "Complete Survey")

  end

  it "view SF scores page if program survey is not completed" do
    submission = FactoryBot.create(
      :submission,
      :complete,
      :semifinalist
    )

    FactoryBot.create(
      :score,
      :complete,
      round: :semifinals,
      team_submission: submission
    )

    student = submission.team.students.sample
    sign_in(student)
    expect(page).to have_content("Before you can view your scores and certificates, please complete the post-survey.")
    expect(page).to have_selector(:link_or_button, "Complete Survey")

  end
end
