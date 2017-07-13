require "rails_helper"

RSpec.feature "Mentors leave their own team" do
  before { SeasonToggles.team_submissions_editable="yes" }

  scenario "leave the team" do
    mentor = FactoryGirl.create(:mentor, :on_team)
    sign_in(mentor)

    within(".navigation") { click_link "My teams" }
    click_link mentor.team_names.last

    click_link "Remove your membership from #{mentor.team_names.last}"
    expect(current_path).to eq(mentor_dashboard_path)

    within(".navigation") { click_link "My teams" }
    expect(page).not_to have_link(Team.last.name)
  end
end
