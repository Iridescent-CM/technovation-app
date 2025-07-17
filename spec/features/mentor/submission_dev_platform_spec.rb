require "rails_helper"

RSpec.feature "Mentors edit submission development platform" do
  before do
    SeasonToggles.team_submissions_editable!

    mentor = FactoryBot.create(:mentor, :onboarded, :on_team)
    FactoryBot.create(:team_submission, team: mentor.teams.first)

    sign_in(mentor)

    click_link "Submit your Project"
    click_link "Edit submission"
    click_link "Technical Elements"
    click_link "Select your coding language"
  end

  scenario "Choose App Inventor" do
    select "App Inventor",
      from: "Which coding language did your team use?"

    click_button "Save"

    expect(page).to have_css(
      ".field_with_errors #team_submission_app_inventor_app_name"
    )

    fill_in "What is your App Inventor Project Name?",
      with: "my_exact_app_name"

    click_button "Save"

    within(".development_platform.complete") do
      expect(page).to have_content "App Inventor"
    end
  end

  scenario "Choose Thunkable" do
    select "Thunkable",
      from: "Which coding language did your team use?"

    click_button "Save"

    expect(page).to have_css(
      ".field_with_errors #team_submission_thunkable_project_url"
    )

    fill_in "What is the URL to your Thunkable project detail page?",
      with: "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"

    click_button "Save"

    within(".development_platform.complete") do
      expect(page).to have_content "Thunkable"
      expect(page).to have_link "https://x.thunkable.com/projectPage/47d800b3aa47590210ad662249e63dd4"
    end
  end
end
