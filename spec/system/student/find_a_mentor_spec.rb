require "rails_helper"

RSpec.describe "Students invite mentors to join their team", :js do
  before { SeasonToggles.team_building_enabled="yes" }

  let(:student) { FactoryBot.create(:student, :geocoded, :on_team) }
  let!(:mentor) { FactoryBot.create(:mentor, :geocoded) }

  before do
    sign_in(student)
    visit student_team_path(student.team)
    click_link "Add a mentor"
  end

  it "Student is not yet on a team" do
    student.memberships.destroy_all

    visit student_dashboard_path
    click_button "2. Build your team"
    click_button "Add a mentor to your team"

    within(".completion-step__find-mentor .step-actions") do
      expect(page).not_to have_link("Search for mentors")
      expect(page).to have_content(
        "When you are on a team, you will be able to search for mentors"
      )
    end
  end
end