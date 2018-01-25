require "rails_helper"

RSpec.feature "Students edit submission code checklist" do
  let!(:student) {
    FactoryBot.create(:onboarded_student, :senior, :on_team)
  }

  let!(:submission) {
    FactoryBot.create(:team_submission, team: student.team)
  }

  before do
    SeasonToggles.team_submissions_editable!
    sign_in(student)
    click_link "My team's submission"
    click_link "Code"
  end

  scenario "visit the checklist" do
    click_link "Confirm your code checklist"

    check "Strings"
    fill_in "technical_checklist[used_strings_explanation]",
      with: "Explained!"
    click_button "Save"

    expect(submission.reload.code_checklist).to be_used_strings
    expect(
      submission.code_checklist.used_strings_explanation
    ).to eq("Explained!")
  end
end
