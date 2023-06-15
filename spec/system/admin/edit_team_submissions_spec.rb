require "rails_helper"

RSpec.describe "Toggling editable team submissions", :js do
  include ActionView::RecordIdentifier

  let(:team) { FactoryBot.create(:team) }

  def set_editable_team_submissions(bool)
    SeasonToggles.team_submissions_editable = !!bool
    expect(SeasonToggles.team_submissions_editable?).to be !!bool
  end

  def create_authenticated_user_on_team(scope, options)
    user = FactoryBot.create(scope, :geocoded)
    TeamRosterManaging.add(team, user)
    FactoryBot.create(:submission, team: team) if options[:submission]
    sign_in(user)
  end

  context "as a student with editing off" do
    before { set_editable_team_submissions(false) }

    it "try to edit an existing submission" do
      create_authenticated_user_on_team(:student, submission: true)

      click_button "Submit your project"

      expect(page).to have_content(
        "Submitting your project is not available right now.\n" +
        "Technovation staff has disabled this feature for everyone."
      )
      expect(page).not_to have_link("Your project's name")

      visit student_team_submission_path(team.reload.submission)
      expect(page).not_to have_css(
        ".button",
        text: "Set your project's name"
      )

      visit student_team_path(team)
      expect(page).not_to have_link("Edit this team's submission")
    end

    it "try to begin a new submission" do
      set_editable_team_submissions(false)
      create_authenticated_user_on_team(:student, submission: false)

      click_button "Submit your project"

      expect(page).to have_content(
        "Submitting your project is not available right now.\n" +
        "Technovation staff has disabled this feature for everyone."
      )
      expect(page).not_to have_link("Begin your submission")

      visit student_team_path(team)
      expect(page).not_to have_link(
        "Start the submission for this team"
      )
    end
  end

  context "as a student with editing on" do
    before { set_editable_team_submissions(true) }

    it "begin and edit a submission" do
      create_authenticated_user_on_team(:student, submission: false)

      click_button "Submit your project"

      within("#your-submission") { click_link "Begin your submission" }
      check "team_submission[integrity_affirmed]"
      click_button "Start now!"

      expect(page).to have_css('.button', text: "Upload your team photo")

      visit student_dashboard_path
      click_button "Submit your project"

      within("#your-submission") do
        expect(page).not_to have_content(
          "Submitting your project is not available right now.\n" +
          "Technovation staff has disabled this feature for everyone."
        )
        expect(page).to have_link(
          "Your project's name",
          href: student_team_submission_path(
            team.reload.submission,
            piece: :app_name
          )
        )
      end
    end
  end
end
