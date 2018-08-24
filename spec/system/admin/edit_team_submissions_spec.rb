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

      click_button "Submit your project"

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

      click_button "Submit your project"

      visit student_team_submission_path(team.reload.submission)
      expect(page).not_to have_link("Confirm your code checklist")

      visit edit_student_team_submission_path(
        team.submission,
        piece: :code_checklist
      )
      expect(current_path).to eq(student_dashboard_path)
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

      expect(page).to have_css('.button', text: "Set your app's name")

      visit student_dashboard_path
      click_button "Submit your project"

      within("#your-submission") do
        expect(page).not_to have_content("Submissions are not editable")
        expect(page).to have_link(
          "Your app's name",
          href: student_team_submission_path(
            team.reload.submission,
            piece: :app_name
          )
        )
      end
    end

    it "edit technical checklist" do
      create_authenticated_user_on_team(:student, submission: true)

      click_button "Submit your project"

      within("#your-submission") { click_link("Code checklist") }

      check "technical_checklist[used_strings]"
      fill_in "technical_checklist[used_strings_explanation]",
        with: "My explanation"

      click_button "Save checklist"

      tc = TechnicalChecklist.last
      expect(tc.used_strings).to be true
      expect(tc.used_strings_explanation).to eq("My explanation")
    end
  end
end