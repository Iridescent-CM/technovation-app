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
    scenario "editing on" do
      set_editable_team_submissions(true)

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

    scenario "editing off, submission exists" do
      set_editable_team_submissions(false)
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

    scenario "editing off, no submission exists" do
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
  end

  context "as a student" do
    scenario "editing on" do
      set_editable_team_submissions(true)
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

    scenario "editing off, submission exists" do
      set_editable_team_submissions(false)
      create_authenticated_user_on_team(:student, submission: true)

      expect(page).to have_content("The submission deadline has passed.")
      expect(page).not_to have_link("Edit your submission")

      visit student_team_submission_path(team.submission)
      expect(page).not_to have_css(".appy-button", text: "Edit")

      visit student_team_path(team)
      expect(page).not_to have_link("Edit this team's submission")
    end

    scenario "editing off, no submission exists" do
      set_editable_team_submissions(false)
      create_authenticated_user_on_team(:student, submission: false)

      expect(page).to have_content("The submission deadline has passed.")
      expect(page).not_to have_link("Begin your submission")

      visit student_team_path(team)
      expect(page).not_to have_link("Start the submission for this team")
    end
  end
end
