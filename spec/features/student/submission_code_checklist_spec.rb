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
  end

  scenario "visit the checklist" do
    click_link "Confirm your code checklist"
    expect(page).to have_css("label", text: "Strings")
  end
end
