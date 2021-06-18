require "rails_helper"

RSpec.describe "Students view scores", :js do
  before { SeasonToggles.display_scores_on! }

  it "Unfinished / unstarted submission" do
    submission = FactoryBot.create(:submission, :incomplete)

    sign_in(submission.team.students.sample)
    click_button "View Scores & Certificate"

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
    click_button "View Scores & Certificate"
    click_link "View your scores and certificate"

    expect(page).to have_selector('.ui-accordion-content', visible: false)
    accordions = page.all(:css, '.ui-accordion-content', visible: false)
    accordions.each do |el|
      execute_script("arguments[0].style.display = 'block'", el)
    end

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
    click_button "View Scores & Certificate"
    click_link "View your scores and certificate"

    expect(page).to have_selector('.ui-accordion-content', visible: false)
    accordions = page.all(:css, '.ui-accordion-content', visible: false)
    accordions.each do |el|
      execute_script("arguments[0].style.display = 'block'", el)
    end

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
    expect(page).to have_content("Congratulations! Your team was a quarterfinalist.")
    expect(page).to have_content("Before you can view your certificate, please complete the post-survey")
    expect(page).to have_selector(:link_or_button, 'View your scores and certificate')

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
    expect(page).to have_content("Congratulations! Your team was a semifinalist.")
    expect(page).to have_content("Before you can view your certificate, please complete the post-survey")
    expect(page).to have_selector(:link_or_button, 'View your scores and certificate')

  end
end
