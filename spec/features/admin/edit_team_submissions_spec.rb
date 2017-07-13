require "rails_helper"

RSpec.feature "Toggling editable team submissions" do
  let(:team) { FactoryGirl.create(:team) }

  def set_editable_team_submissions(bool)
    SeasonToggles.team_submissions_editable = bool
  end

  def create_authenticated_user_on_team(scope, options)
    user = FactoryGirl.create(scope)
    TeamRosterManaging.add(team, user)
    FactoryGirl.create(:submission, team: team) if options[:submission]
    sign_in(user)
  end

  context "as a mentor" do
    context "with editing on" do
      before { set_editable_team_submissions(true) }

      scenario "start and edit new submission" do
        create_authenticated_user_on_team(:mentor, submission: false)

        within("#team-submission-team-list-team-#{team.id}") do
          click_link "Start the submission for this team"
        end

        check "team_submission[integrity_affirmed]"
        click_button "Get Started"

        expect(page).to have_css('.appy-button', text: "Edit")

        visit mentor_dashboard_path

        within("#team-submission-team-list-team-#{team.id}") do
          expect(page).not_to have_content("The submission deadline has passed.")
          expect(page).to have_link(
            "Edit this team's submission",
            href: mentor_team_submission_path(team.submission, team_id: team.id)
          )
        end
      end

      scenario "edit technical checklist" do
        create_authenticated_user_on_team(:mentor, submission: true)

        within("#team-submission-team-list-team-#{team.id}") do
          click_link("Edit this team's submission")
        end

        click_link "Edit Your Technical Checklist"

        check "technical_checklist[used_strings]"
        fill_in "technical_checklist[used_strings_explanation]",
          with: "My explanation"

        click_button "Save checklist"

        tc = TechnicalChecklist.last
        expect(tc.used_strings).to be true
        expect(tc.used_strings_explanation).to eq("My explanation")
      end
    end

    context "with editing off" do
      before { set_editable_team_submissions(false) }

      scenario "try to edit existing submission" do
        create_authenticated_user_on_team(:mentor, submission: true)

        within("#team-submission-team-list-team-#{team.id}") do
          expect(page).to have_content("The submission deadline has passed.")
          expect(page).not_to have_link("Edit this team's submission")
        end

        visit mentor_team_submission_path(team.submission, team_id: team.id)
        expect(page).not_to have_css(".appy-button", text: "Edit")

        visit mentor_team_path(team)
        expect(page).not_to have_link("Edit this team's submission")
      end

      scenario "try to begin a new submission" do
        set_editable_team_submissions(false)
        create_authenticated_user_on_team(:mentor, submission: false)

        within("#team-submission-team-list-team-#{team.id}") do
          expect(page).to have_content("The submission deadline has passed.")
          expect(page).not_to have_link("Start the submission for this team")
        end

        visit mentor_team_path(team)
        expect(page).not_to have_link("Start this team's submission now")

        visit mentor_teams_path
        expect(page).not_to have_link("Start a submission now")
      end

      scenario "try to edit technical checklist" do
        create_authenticated_user_on_team(:mentor, submission: true)

        visit mentor_team_submission_path(team.submission, team_id: team.id)
        expect(page).not_to have_link("Edit Your Technical Checklist")

        visit edit_mentor_technical_checklist_path(team_id: team.id)
        expect(current_path).to eq(mentor_dashboard_path)
      end
    end
  end

  context "as a student" do
    context "with editing on" do
      before { set_editable_team_submissions(true) }

      scenario "begin and edit a submission" do
        create_authenticated_user_on_team(:student, submission: false)

        within("#your-submission") { click_link "Begin your submission" }
        check "team_submission[integrity_affirmed]"
        click_button "Get Started"

        expect(page).to have_css('.appy-button', text: "Edit")

        visit student_dashboard_path
        within("#your-submission") do
          expect(page).not_to have_content("The submission deadline has passed.")
          expect(page).to have_link(
            "Edit your submission",
            href: student_team_submission_path(team.submission)
          )
        end
      end

      scenario "edit technical checklist" do
        create_authenticated_user_on_team(:student, submission: true)

        within("#your-submission") { click_link("Edit your submission") }
        click_link "Edit Your Technical Checklist"

        check "technical_checklist[used_strings]"
        fill_in "technical_checklist[used_strings_explanation]",
          with: "My explanation"

        click_button "Save checklist"

        tc = TechnicalChecklist.last
        expect(tc.used_strings).to be true
        expect(tc.used_strings_explanation).to eq("My explanation")
      end
    end

    context "with editing off" do
      before { set_editable_team_submissions(false) }

      scenario "try to edit an existing submission" do
        create_authenticated_user_on_team(:student, submission: true)

        expect(page).to have_content("The submission deadline has passed.")
        expect(page).not_to have_link("Edit your submission")

        visit student_team_submission_path(team.submission)
        expect(page).not_to have_css(".appy-button", text: "Edit")

        visit student_team_path(team)
        expect(page).not_to have_link("Edit this team's submission")
      end

      scenario "try to begin a new submission" do
        set_editable_team_submissions(false)
        create_authenticated_user_on_team(:student, submission: false)

        expect(page).to have_content("The submission deadline has passed.")
        expect(page).not_to have_link("Begin your submission")

        visit student_team_path(team)
        expect(page).not_to have_link("Start the submission for this team")
      end

      scenario "try to edit technical checklist" do
        create_authenticated_user_on_team(:student, submission: true)

        visit student_team_submission_path(team.submission, team_id: team.id)
        expect(page).not_to have_link("Edit Your Technical Checklist")

        visit edit_student_technical_checklist_path(team_id: team.id)
        expect(current_path).to eq(student_dashboard_path)
      end
    end
  end
end
