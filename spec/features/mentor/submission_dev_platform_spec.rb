require "rails_helper"

RSpec.feature "Mentors edit submission development platform" do
  before do
    SeasonToggles.team_submissions_editable!

    mentor = FactoryBot.create(:mentor, :onboarded, :on_team)
    FactoryBot.create(:team_submission, team: mentor.teams.first)

    sign_in(mentor)

    within("#find-team") { click_link "Edit this team's submission" }
    click_link "Technical Elements"
    click_link "Select your submission type"
  end

  scenario "Choose App Inventor" do
    select "Mobile App",
      from: "Submission type"

    select "App Inventor",
      from: "Which coding language did your team use?"

    click_button "Save"

    expect(page).to have_css(
      ".field_with_errors #team_submission_app_inventor_app_name",
    )

    expect(page).to have_css(
      ".field_with_errors #team_submission_app_inventor_gmail",
    )

    fill_in "What is your App Inventor Project Name?",
      with: "my_exact_app_name"

    fill_in "What is the gmail address of the App Inventor " +
            "account that your team is using?",
      with: "my@gmail.com"

    click_button "Save"

    within(".development_platform.complete") do
      expect(page).to have_content "App Inventor"
    end
  end

  scenario "Choose Thunkable" do
    select "Mobile App",
      from: "Submission type"

    select "Thunkable",
      from: "Which coding language did your team use?"

    click_button "Save"

    expect(page).to have_css(
      ".field_with_errors #team_submission_thunkable_project_url",
    )

    expect(page).to have_css(
      ".field_with_errors #team_submission_thunkable_account_email",
    )

    fill_in "What is the email address of your team's Thunkable account?",
      with: "our-team@thunkable.com"

    fill_in "What is the URL to your Thunkable project? Copy your URL from the address bar of your Thunkable project. For more information, go <a href="https://iridescentsupport.zendesk.com/hc/en-us/articles/360019590314-How-do-I-submit-my-source-code-" target="_blank">here.</a>",
      with: "https://x.thunkable.com/projects/47d800b3aa47590210ad662249e63dd4"

    click_button "Save"

    within(".development_platform.complete") do
      expect(page).to have_content "Thunkable"
      expect(page).to have_link "https://x.thunkable.com/projects/47d800b3aa47590210ad662249e63dd4"
    end
  end
end
