require "rails_helper"

RSpec.feature "Students view scores" do
  before { SeasonToggles.display_scores_on! }

  scenario "Unfinished / unstarted submission" do
    submission = FactoryBot.create(:submission, :incomplete)

    sign_in(submission.team.students.sample)

    expect(page).to have_content("Thank you for your participation")
    expect(page).to have_content(
      "Unfortunately, no scores are available for your team " +
      "because your submission was incomplete"
    )
  end

  scenario "view QF scores" do
    submission = FactoryBot.create(
      :submission,
      :complete,
      technical_checklist_attributes: {
        used_camera: true,
        used_camera_explanation: "We did it...",
      }
    )

    FactoryBot.create(:submission_score, :complete, team_submission: submission)

    sign_in(submission.team.students.sample)
    click_link "View your scores and certificate"

    expect(page).to have_content("earned 2 points")
  end

  scenario "view SF scores" do
    submission = FactoryBot.create(
      :submission,
      :complete,
      :semifinalist,
      technical_checklist_attributes: {
        used_camera: true,
        used_camera_explanation: "We did it...",
      }
    )

    FactoryBot.create(
      :score,
      :complete,
      round: :semifinals,
      team_submission: submission
    )

    sign_in(submission.team.students.sample)
    click_link "View your scores and certificate"

    expect(page).to have_content("earned 2 points")
  end
end
