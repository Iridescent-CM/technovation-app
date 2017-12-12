require "rails_helper"

RSpec.feature "Mentors leave their own team" do
  before { SeasonToggles.team_building_enabled="yes" }

  scenario "leave the team" do
    mentor = FactoryBot.create(:mentor, :on_team)
    sign_in(mentor)

    click_link mentor.team_names.last

    click_link "remove this member"
    expect(current_path).to eq(mentor_dashboard_path)

    expect(page).not_to have_link(Team.last.name)
  end
end
