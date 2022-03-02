require "rails_helper"

RSpec.feature "Students edit submission development platform" do
  let(:student) { FactoryBot.create(:student, :on_team, :geocoded) }

  before do
    SeasonToggles.team_submissions_editable!

    FactoryBot.create(
      :team_submission,
      team: student.team,
    )

    sign_in(student)

    click_link "My Submission"
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

    fill_in "What is your App Inventor Project Name?", with: "my_exact_app_name"

    fill_in "What is the gmail address of the App Inventor account that your team is using?",
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

    fill_in "What is the URL to your Thunkable project?",
      with: "https://x.thunkable.com/projects/47d800b3aa47590210ad662249e63dd4"

    click_button "Save"

    within(".development_platform.complete") do
      expect(page).to have_content "Thunkable"
      expect(page).to have_link "https://x.thunkable.com/projects/47d800b3aa47590210ad662249e63dd4"
    end
  end
end
