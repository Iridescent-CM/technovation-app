require "rails_helper"

RSpec.feature "Student team submissions" do

  before { SeasonToggles.team_submissions_editable! }

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

  scenario "Confirm submissions are created solely by team students" do
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
    submission = FactoryBot.create(:team_submission, team: student.team)
    sign_in(student)

    click_link "My team's submission"

    expect(page).to have_link(
      "Set your app's name",
      href: edit_student_team_submission_path(
        submission,
        piece: :app_name
      )
    )

    expect(page).to have_link(
      "Add your app's description",
      href: edit_student_team_submission_path(
        submission,
        piece: :app_description
      )
    )

    expect(page).to have_link(
      "Add the demo video link",
      href: edit_student_team_submission_path(
        submission,
        piece: :demo_video_link
      )
    )

    expect(page).to have_link(
      "Add the pitch video link",
      href: edit_student_team_submission_path(
        submission,
        piece: :pitch_video_link
      )
    )

    expect(page).to have_link(
      "Select the development platform that your team used",
      href: edit_student_team_submission_path(
        submission,
        piece: :development_platform
      )
    )

    expect(page).to have_link(
      "Upload your app's source code",
      href: edit_student_team_submission_path(
        submission,
        piece: :source_code
      )
    )

    expect(page).to have_link(
      "Upload screenshots of your app",
      href: edit_student_team_submission_path(
        submission,
        piece: :screenshots
      )
    )
  end

  scenario "See senior team submission pieces on TOC" do
    student = FactoryBot.create(:student, :on_team)
    submission = FactoryBot.create(:team_submission, team: student.team)

    sign_in(student)

    click_link "My team's submission"

    expect(page).not_to have_link(
      "Upload your team's business plan",
    )

    expect(page).to have_content("Your team is in the Junior Division")
    expect(page).to have_content(
      "Uploading a business plan is not required " +
      "in the Junior Division. If your team has " +
      "put one together, that is awesome! Hold on " +
      "to it for your own records and be extremely proud!"
    )

    ProfileUpdating.execute(student, :student, account_attributes: {
      id: student.account_id,
      date_of_birth: 15.years.ago,
    })

    click_link "My team's submission"

    expect(page).to have_link(
      "Upload your team's business plan",
      href: edit_student_team_submission_path(
        submission,
        piece: :business_plan
      )
    )
  end

  scenario "See live pitch event submission pieces on TOC" do
    student = FactoryBot.create(:student, :on_team)
    submission = FactoryBot.create(:team_submission, team: student.team)

    sign_in(student)

    click_link "My team's submission"

    expect(page).not_to have_link(
      "Upload the pitch presentation slides for your live event",
    )

    expect(page).to have_content(
      "Your team is not set to attend a live regional pitch event."
    )

    expect(page).to have_content(
      "If your team is invited, then you will " +
      "be required to upload your pitch presentation slides here."
    )

    rpe = FactoryBot.create(:regional_pitch_event)
    rpe.teams << student.team

    click_link "My team's submission"

    expect(page).to have_link(
      "Upload the pitch presentation slides for your live event",
      href: edit_student_team_submission_path(
        submission,
        piece: :pitch_presentation
      )
    )
  end
end
