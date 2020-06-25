require "rails_helper"

RSpec.describe "Students view scores", :js do
  before { SeasonToggles.display_scores_on! }

  it "Unfinished / unstarted submission" do
    submission = FactoryBot.create(:submission, :incomplete)

    sign_in(submission.team.students.sample)
    click_button "Scores & Certificates"

    expect(page).to have_content("Thank you for your participation")
    expect(page).to have_content(
      "Unfortunately, no scores are available for your team " +
      "because your submission was incomplete"
    )
  end

  it "view QF scores" do
    submission = FactoryBot.create(
      :submission,
      :complete,
    )

    FactoryBot.create(:submission_score, :complete, team_submission: submission)

    sign_in(submission.team.students.sample)
    click_button "Scores & Certificates"
    click_link "View your scores and certificate"

    expect(page).to have_selector('.ui-accordion-content', visible: false)
    accordions = page.all(:css, '.ui-accordion-content', visible: false)
    accordions.each do |el|
      execute_script("arguments[0].style.display = 'block'", el)
    end

    expect(page).to have_content("Scores Explained")
  end

  it "view SF scores" do
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

    sign_in(submission.team.students.sample)
    click_button "Scores & Certificates"
    click_link "View your scores and certificate"

    expect(page).to have_selector('.ui-accordion-content', visible: false)
    accordions = page.all(:css, '.ui-accordion-content', visible: false)
    accordions.each do |el|
      execute_script("arguments[0].style.display = 'block'", el)
    end

    expect(page).to have_content("Scores Explained")
  end
end
