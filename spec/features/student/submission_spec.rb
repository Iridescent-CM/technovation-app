require "rails_helper"

RSpec.feature "Student team submissions" do
  scenario "Be on a team to see submission link" do
    student = FactoryGirl.create(:student)
    team_student = FactoryGirl.create(:student, :on_team)

    sign_in(student)
    expect(page).not_to have_link("My team's submission", href: new_student_team_submission_path)

    sign_out
    sign_in(team_student)
    expect(page).to have_link("My team's submission", href: new_student_team_submission_path)
  end

  scenario "Confirm that submission deliverables were created solely by team students" do
    student = FactoryGirl.create(:student, :on_team)
    sign_in(student)

    click_link "My team's submission"

    check "This submission and all deliverables included were created solely by the students on this team."
    click_button "Get Started"

    expect(current_path).to eq(student_team_submission_path(TeamSubmission.last))
    expect(page).to have_link("My team's submission", href: student_team_submission_path(TeamSubmission.last))
  end
end
