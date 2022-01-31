require "rails_helper"

RSpec.feature "Student team submissions" do

  before { SeasonToggles.team_submissions_editable! }

  let(:senior_division_age) { Division::SENIOR_DIVISION_AGE }
  let(:senior_dob) { Division.cutoff_date - senior_division_age.years }

  scenario "Be on a team to see submission link" do
    student = FactoryBot.create(:student)
    team_student = FactoryBot.create(:student, :on_team, :geocoded)

    sign_in(student)
    expect(page).not_to have_link(
      "My team's submission",
      href: new_student_team_submission_path
    )

    sign_out
    sign_in(team_student)
    expect(page).to have_link(
      "My Submission",
      href: new_student_team_submission_path
    )
  end

  scenario "Confirm submissions are created solely by team students" do
    student = FactoryBot.create(:student, :on_team, :geocoded)
    sign_in(student)

    click_link "My Submission"

    check "team_submission[integrity_affirmed]"
    click_button "Start now!"

    expect(current_path).to eq(
      student_team_submission_section_path(TeamSubmission.last)
    )
    expect(page).to have_link(
      "My Submission",
      href: student_team_submission_path(TeamSubmission.last)
    )
  end

  scenario "Start the submission from the table of contents" do
    student = FactoryBot.create(:student, :on_team, :geocoded)
    submission = FactoryBot.create(:team_submission, team: student.team)
    sign_in(student)

    click_link "My Submission"
    click_link "Ideation"

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
      "Upload images of your app",
      href: edit_student_team_submission_path(
        submission,
        piece: :screenshots
      )
    )

    click_link "Pitch"

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

    click_link "Technical Elements"

    expect(page).to have_link(
      "Select your submission type",
      href: edit_student_team_submission_path(
        submission,
        piece: :development_platform
      )
    )

    expect(page).to have_link(
      "Upload your technical work",
      href: edit_student_team_submission_path(
        submission,
        piece: :source_code_url
      )
    )
  end

  scenario "See senior team submission pieces on TOC" do
    student = FactoryBot.create(:student, :on_team, :geocoded)
    submission = FactoryBot.create(:team_submission, team: student.team)

    sign_in(student)

    click_link "My Submission"
    click_link "Entrepreneurship"

    expect(page).to have_link(
      "Upload your team's plan"
    )

    expect(page).to have_content("User Adoption Plan")

    ProfileUpdating.execute(student, :student, account_attributes: {
      id: student.account_id,
      date_of_birth: senior_dob
    })

    click_link "My Submission"
    click_link "Entrepreneurship"

    expect(page).to have_link(
      "Upload your team's plan",
      href: edit_student_team_submission_path(
        submission,
        piece: :business_plan
      )
    )
  end

  xscenario "See live pitch event submission pieces on TOC" do
    student = FactoryBot.create(:student, :on_team, :geocoded)
    submission = FactoryBot.create(:team_submission, team: student.team)

    sign_in(student)

    click_link "My Submission"
    click_link "Regional events"

    expect(page).not_to have_link(
      "Upload the pitch presentation slides for your live event",
    )

    expect(page).to have_content(
      "No team will submit pitch presentation slides here because all " +
      "official Regional Pitch Events are canceled due to COVID this season."
    )

    expect(page).to have_content(
      "If you are attending a local celebration or unofficial pitch event, your " +
      "Chapter Ambassador may ask you to share your pitch presentation slides with " +
      "them before the event. Coordinate with them directly and good luck!"
    )

    rpe = FactoryBot.create(:regional_pitch_event)
    rpe.teams << student.team

    click_link "My Submission"
    click_link "Regional events"

    expect(page).to have_link(
      "Upload the pitch presentation slides for your live event",
      href: edit_student_team_submission_path(
        submission,
        piece: :pitch_presentation
      )
    )
  end
end
