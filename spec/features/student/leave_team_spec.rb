require "rails_helper"

RSpec.feature "Students leaving their own team" do
  include ActionView::RecordIdentifier

  before { SeasonToggles.team_building_enabled = "yes" }

  scenario "A student removing themselves from their own team" do
    student = FactoryBot.create(:student, :on_team, :geocoded)

    sign_in(student)
    click_link "My Team"
    click_link "Remove"

    expect(current_path).to eq(student_dashboard_path)
    expect(page).to have_link("Create your team")
  end
end
