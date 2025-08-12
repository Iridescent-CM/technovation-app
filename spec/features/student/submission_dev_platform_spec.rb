require "rails_helper"

RSpec.feature "Students edit submission development platform" do
  let(:student) { FactoryBot.create(:student, :on_team, :geocoded, :beginner) }

  before do
    SeasonToggles.team_submissions_editable!

    FactoryBot.create(
      :team_submission,
      team: student.team
    )

    sign_in(student)

    click_link "My Submission"
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

    fill_in "What is your App Inventor Project Name?", with: "my_exact_app_name"

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

  scenario "Choose Scratch" do
    select "Scratch",
      from: "Which coding language did your team use?"

    click_button "Save"

    expect(page).not_to have_css(
      ".field_with_errors #team_submission_scratch_project_url"
    )

    click_link "Change your selection"

    fill_in "What is the URL for your Scratch project page?",
      with: "https://scratch.mit.edu/projects/12345"

    click_button "Save"

    within(".development_platform.complete") do
      expect(page).to have_content "Scratch"
      expect(page).to have_link "https://scratch.mit.edu/projects/12345"
    end
  end

  scenario "Choose Code.org App Lab" do
    select "Code.org App Lab",
      from: "Which coding language did your team use?"

    click_button "Save"

    expect(page).to have_css(
      ".field_with_errors #team_submission_code_org_app_lab_project_url"
    )

    fill_in "What is the URL to your Code.org App Lab project?",
      with: "https://studio.code.org/projects/applab/12345"

    click_button "Save"

    within(".development_platform.complete") do
      expect(page).to have_content "Code.org App Lab"
      expect(page).to have_link "https://studio.code.org/projects/applab/12345"
    end
  end
end
