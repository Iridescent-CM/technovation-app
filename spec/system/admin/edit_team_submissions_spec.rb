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

      click_button "3. Submit your project"

      expect(page).to have_content("Submissions are not editable")
      expect(page).not_to have_link("Your app's name")

      visit student_team_submission_path(team.reload.submission)
      expect(page).not_to have_css(
        ".button",
        text: "Set your app's name"
      )

      visit student_team_path(team)
      expect(page).not_to have_link("Edit this team's submission")
    end

    it "try to begin a new submission" do
      set_editable_team_submissions(false)
      create_authenticated_user_on_team(:student, submission: false)

      click_button "3. Submit your project"

      expect(page).to have_content(
        "Starting a submission is not available"
      )
      expect(page).not_to have_link("Begin your submission")

      visit student_team_path(team)
      expect(page).not_to have_link(
        "Start the submission for this team"
      )
    end

    it "try to edit technical checklist" do
      create_authenticated_user_on_team(:student, submission: true)

      visit student_team_submission_path(team.reload.submission)
      expect(page).not_to have_link("Confirm your code checklist")

      visit edit_student_team_submission_path(
        team.submission,
        piece: :code_checklist
      )
      expect(current_path).to eq(student_dashboard_path)
    end
  end
end