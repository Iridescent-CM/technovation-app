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
    student = FactoryBot.create(:student)
    team_student = FactoryBot.create(:student, :on_team)

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
    student = FactoryBot.create(:student, :on_team)
    sign_in(student)

    click_link "My team's submission"

    check "team_submission[integrity_affirmed]"
    click_button "Start now!"

    expect(current_path).to eq(
      student_team_submission_path(TeamSubmission.last)
    )
    expect(page).to have_link(
      "My team's submission",
      href: student_team_submission_path(TeamSubmission.last)
    )
  end

  scenario "Start the submission from the table of contents" do
    student = FactoryBot.create(:student, :on_team)
    submission = student.team.team_submissions.create!({ integrity_affirmed: true })
    sign_in(student)


    click_link "My team's submission"

    expect(page).to have_link(
      "Set your app's name",
      href: edit_student_team_submission_path(submission, piece: :app_name)
    )

    expect(page).to have_link(
      "Add your app's description",
      href: edit_student_team_submission_path(submission, piece: :app_description)
    )

    expect(page).to have_link(
      "Add the demo video link",
      href: edit_student_team_submission_path(submission, piece: :demo_video_link)
    )

    expect(page).to have_link(
      "Add the pitch video link",
      href: edit_student_team_submission_path(submission, piece: :pitch_video_link)
    )

    expect(page).to have_link(
      "Select the development platform that your team used",
      href: edit_student_team_submission_path(submission, piece: :development_platform)
    )

    expect(page).to have_link(
      "Upload your app's source code",
      href: edit_student_team_submission_path(submission, piece: :source_code)
    )

    expect(page).to have_link(
      "Upload screenshots of your app",
      href: edit_student_team_submission_path(submission, piece: :screenshots)
    )
  end

  scenario "See senior team submission pieces on TOC"
  scenario "See live pitch event submission pieces on TOC"
end
