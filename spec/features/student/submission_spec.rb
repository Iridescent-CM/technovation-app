require "rails_helper"

RSpec.feature "Student team submissions" do

  before do
    @editable_submissions = SeasonToggles.team_submissions_editable?
    SeasonToggles.team_submissions_editable = true
  end

  after do
    SeasonToggles.team_submissions_editable = @editable_submissions
  end

  scenario "Be on a team to see submission link" do
    student = FactoryGirl.create(:student)
    team_student = FactoryGirl.create(:student, :on_team)

    sign_in(student)
    expect(page).not_to have_link(
      "My team's submission",
      href: new_student_team_submission_path
    )

    sign_out
    sign_in(team_student)
    expect(page).to have_link(
      "My team's submission",
      href: new_student_team_submission_path
    )
  end

  scenario "Confirm submission deliverables are created solely by team students" do
    student = FactoryGirl.create(:student, :on_team)
    sign_in(student)

    click_link "My team's submission"

    check "team_submission[integrity_affirmed]"
    click_button "Get Started"

    expect(current_path).to eq(
      student_team_submission_path(TeamSubmission.last)
    )
    expect(page).to have_link(
      "My team's submission",
      href: student_team_submission_path(TeamSubmission.last)
    )
  end
end
