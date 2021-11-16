require "rails_helper"

RSpec.feature "Students leave their own team" do
  include ActionView::RecordIdentifier

  before { SeasonToggles.team_building_enabled="yes" }

  scenario "leave the team" do
    student = FactoryBot.create(:student, :on_team, :geocoded)

    sign_in(student)
    click_link "My Team"

    within("##{dom_id(student)}") do
      click_link "remove this member"
    end

    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_link("Create your team")
  end
end
