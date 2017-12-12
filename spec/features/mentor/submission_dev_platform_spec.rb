require "rails_helper"

RSpec.feature "Students edit submission development platform" do
  scenario "Choose App Inventor" do
    SeasonToggles.team_submissions_editable!

    mentor = FactoryBot.create(:mentor, :on_team)
    mentor.teams.first.team_submissions.create!({ integrity_affirmed: true })

    sign_in(mentor)

    click_link "Edit this team's submission"
    click_link "Select the development platform that your team used"

    select "App Inventor", from: "Which development platform did your team use?"

    click_button "Save"

    expect(page).to have_css(
      ".field_with_errors #team_submission_app_inventor_app_name",
    )

    expect(page).to have_css(
      ".field_with_errors #team_submission_app_inventor_gmail",
    )

    fill_in "What is your App Inventor 2 Project Name?", with: "my exact app name"

    fill_in "What is the gmail address of the App Inventor 2 account that your team is using?",
      with: "my@gmail.com"

    click_button "Save"

    within(".development_platform.complete") do
      expect(page).to have_content "App Inventor 2"
    end
  end
end
