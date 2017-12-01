require "rails_helper"

RSpec.feature "Students edit submission pieces" do
  let!(:student) { FactoryBot.create(:onboarded_student, :on_team) }
  let!(:submission) { student.team.team_submissions.create!({ integrity_affirmed: true }) }

  before do
    SeasonToggles.team_submissions_editable!
    sign_in(student)
    click_link "My team's submission"
  end

  scenario "Set the app name" do
    within(".app_name.incomplete") do
      click_link "Set your app's name"
    end

    fill_in "Your app's name", with: "WonderApp2018"
    click_button "Save this name"

    expect(current_path).to eq(student_team_submission_path(submission.reload))

    within(".app_name.complete") do
      expect(page).not_to have_link("Set your app's name")

      expect(page).to have_content "WonderApp2018"
      expect(page).to have_link(
        "Change your app's name",
        href: edit_student_team_submission_path(submission, piece: :app_name)
      )
    end
  end

  scenario "Set the app description" do
    within(".app_description.incomplete") do
      click_link "Add your app's description"
    end

    fill_in "Describe your app in only a few sentences or less",
      with: "Only a few sentences"

    click_button "Save this description"

    expect(current_path).to eq(student_team_submission_path(submission))

    within(".app_description.complete") do
      expect(page).not_to have_link("Add your app's description")

      expect(page).to have_content "Only a few sentences"
      expect(page).to have_link(
        "Change your app's description",
        href: edit_student_team_submission_path(submission, piece: :app_description)
      )
    end
  end
end
