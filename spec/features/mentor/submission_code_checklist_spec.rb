require "rails_helper"

RSpec.feature "Mentors edit submission code checklist" do
  let!(:mentor) {
    FactoryBot.create(:onboarded_mentor, :on_team)
  }

  let!(:submission) {
    FactoryBot.create(:team_submission, team: mentor.teams.first)
  }

  before do
    SeasonToggles.team_submissions_editable!
    sign_in(mentor)
    click_link "Edit this team's submission"
  end

  scenario "visit the checklist" do
    click_link "Code"
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
