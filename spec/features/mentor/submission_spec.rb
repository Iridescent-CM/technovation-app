require "rails_helper"

RSpec.feature "Student team submissions" do
  let(:senior_division_age) { Division::SENIOR_DIVISION_AGE }
  let(:senior_dob) { Division.cutoff_date - senior_division_age.years }

  before { SeasonToggles.team_submissions_editable! }

  scenario "Be on a team to see submission link" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    team_mentor = FactoryBot.create(:mentor, :onboarded, :on_junior_team)

    sign_in(mentor)

    expect(page).not_to have_link("Start a submission now")

    sign_out
    sign_in(team_mentor)

    within("#find-team") {
      expect(page).to have_link(
        "Start a submission now",
        href: new_mentor_team_submission_path(
          team_id: team_mentor.teams.first.id
        )
      )
    }
  end

  scenario "Confirm submissions are created solely by team students" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_junior_team)
    sign_in(mentor)

    within("#find-team") { click_link "Start a submission now" }

    check "team_submission[integrity_affirmed]"
    click_button "Start now!"

    expect(current_path).to eq(
      mentor_team_submission_section_path(
        TeamSubmission.last,
      )
    )
  end

  scenario "Start the submission from the table of contents" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_junior_team)
    submission = FactoryBot.create(
      :team_submission,
      team: mentor.teams.first,
    )

    sign_in(mentor)

    within("#find-team") { click_link "Edit this team's submission" }

    expect(page).to have_link(
      "Set your project's name",
      href: edit_mentor_team_submission_path(
        submission,
        piece: :app_name
      )
    )

    expect(page).to have_link(
      "Add your project's description",
      href: edit_mentor_team_submission_path(
        submission,
        piece: :app_description
      )
    )

    expect(page).to have_link(
      "Upload images of your product",
      href: edit_mentor_team_submission_path(
        submission,
        piece: :screenshots
      )
    )

    click_link "Pitch"

    expect(page).to have_link(
      "Add the technical video link",
      href: edit_mentor_team_submission_path(
        submission,
        piece: :demo_video_link
      )
    )

    expect(page).to have_link(
      "Add the pitch video link",
      href: edit_mentor_team_submission_path(
        submission,
        piece: :pitch_video_link
      )
    )

    click_link "Technical Elements"

    expect(page).to have_link(
      "Select your submission type",
      href: edit_mentor_team_submission_path(
        submission,
        piece: :development_platform
      )
    )

    expect(page).to have_link(
      "Upload your technical work",
      href: edit_mentor_team_submission_path(
        submission,
        piece: :source_code_url
      )
    )
  end

  scenario "See senior team submission pieces on TOC" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_junior_team)
    submission = FactoryBot.create(
      :team_submission,
      team: mentor.teams.first
    )

    sign_in(mentor)

    within("#find-team") { click_link "Edit this team's submission" }

    click_link "Entrepreneurship"

    expect(page).to have_link(
      "Upload your team's plan"
    )

    expect(page).to have_content("User Adoption Plan")

    student = mentor.teams.first.students.first
    ProfileUpdating.execute(student, :student, account_attributes: {
      id: student.account_id,
      date_of_birth: senior_dob
    })

    visit mentor_dashboard_path
    within("#find-team") { click_link "Edit this team's submission" }

    click_link "Entrepreneurship"

    expect(page).to have_link(
      "Upload your team's plan",
      href: edit_mentor_team_submission_path(
        submission,
        piece: :business_plan
      )
    )
  end

  xscenario "See live pitch event submission pieces on TOC" do
    mentor = FactoryBot.create(:mentor, :onboarded, :on_junior_team)
    submission = FactoryBot.create(
      :team_submission,
      team: mentor.teams.first,
    )

    sign_in(mentor)

    within("#find-team") { click_link "Edit this team's submission" }
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
    rpe.teams << mentor.teams.first

    visit mentor_dashboard_path
    within("#find-team") { click_link "Edit this team's submission" }
    click_link "Regional events"

    expect(page).to have_link(
      "Upload the pitch presentation slides for your live event",
      href: edit_mentor_team_submission_path(
        submission,
        piece: :pitch_presentation
      )
    )
  end
end
