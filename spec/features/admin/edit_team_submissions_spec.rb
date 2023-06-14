require "rails_helper"

RSpec.feature "Toggling editable team submissions" do
  include ActionView::RecordIdentifier

  let(:team) { FactoryBot.create(:team) }

  def set_editable_team_submissions(bool)
    SeasonToggles.team_submissions_editable = !!bool
    expect(SeasonToggles.team_submissions_editable?).to be !!bool
  end

  def create_authenticated_user_on_team(scope, options)
    user = FactoryBot.create(scope, :geocoded, :onboarded)
    TeamRosterManaging.add(team, user)
    FactoryBot.create(:submission, team: team) if options[:submission]
    sign_in(user)
  end

  context "as a mentor" do
    context "with editing on" do
      before { set_editable_team_submissions(true) }

      scenario "start and edit new submission" do
        create_authenticated_user_on_team(:mentor, submission: false)

        within("#find-team") do
          click_link "Start a submission now"
        end

        check "team_submission[integrity_affirmed]"
        click_button "Start now!"

        expect(page).to have_css('.button', text: "Upload your team photo")

        visit mentor_dashboard_path

        within("#find-team") do
          expect(page).not_to have_content(
            "Starting a submission is not currently enabled."
          )
          expect(page).to have_link(
            "Edit this team's submission",
            href: mentor_team_submission_path(team.reload.submission)
          )
        end
      end
    end

    context "with editing off" do
      before { set_editable_team_submissions(false) }

      scenario "try to edit existing submission" do
        create_authenticated_user_on_team(:mentor, submission: true)

        within("#find-team") do
          expect(page).to have_content(
            "Submissions are not editable at this time"
          )
          expect(page).not_to have_link("Edit this team's submission")
        end

        visit mentor_team_submission_path(team.reload.submission)
        expect(page).not_to have_css(
          ".button",
          text: "Set your project's name"
        )

        visit mentor_team_path(team)
        expect(page).not_to have_link("Edit this team's submission")
      end

      scenario "try to begin a new submission" do
        set_editable_team_submissions(false)
        create_authenticated_user_on_team(:mentor, submission: false)

        within("#find-team") do
          expect(page).not_to have_link("Start a submission now")
          expect(page).to have_content(
            "Submissions may not be started at this time."
          )
        end

        visit mentor_team_path(team)
        expect(page).not_to have_link("Start this team's submission now")

        visit mentor_dashboard_path
        expect(page).not_to have_link("Start a submission now")
      end
    end
  end
end
