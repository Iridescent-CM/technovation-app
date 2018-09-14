require "rails_helper"

RSpec.feature "Students edit submission development platform" do
  scenario "Choose App Inventor" do
    SeasonToggles.team_submissions_editable!

    student = FactoryBot.create(:student, :on_team, :geocoded)
    FactoryBot.create(
      :team_submission,
      team: student.team,
    )

    sign_in(student)

    click_link "My team's submission"
    click_link "Code"
    click_link "Select your development platform"

    select "App Inventor",
      from: "Which development platform did your team use?"

    click_button "Save"

    expect(page).to have_css(
      ".field_with_errors #team_submission_app_inventor_app_name",
    )

    expect(page).to have_css(
      ".field_with_errors #team_submission_app_inventor_gmail",
    )

    fill_in "What is your App Inventor Project Name?", with: "my exact app name"

    fill_in "What is the gmail address of the App Inventor account that your team is using?",
      with: "my@gmail.com"

    click_button "Save"

    within(".development_platform.complete") do
      expect(page).to have_content "App Inventor"
    end
  end
end
