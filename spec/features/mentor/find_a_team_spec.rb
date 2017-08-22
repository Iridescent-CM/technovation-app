require "rails_helper"

RSpec.feature "Mentors find a team" do
  before { SeasonToggles.team_building_enabled="yes" }

  let!(:available_team) { FactoryGirl.create(:team, :geocoded) } # Default is in Chicago

  before do
    mentor = FactoryGirl.create(:mentor, :geocoded) # City is Chicago
    sign_in(mentor)
  end

  scenario "browse nearby teams" do
    mentored_team = FactoryGirl.create(:team, :with_mentor, :geocoded) # Default is in Chicago
    faraway_team = FactoryGirl.create(
      :team,
      :geocoded,
      city: "Los Angeles",
      state_province: "CA"
    )

    within('#submissions') { click_link "Join a team" }

    expect(page).to have_css(".search-result-head", text: available_team.name)
    expect(page).to have_css(".search-result-head", text: mentored_team.name)
    expect(page).not_to have_css(".search-result-head", text: faraway_team.name)
  end

  scenario "request to join a team" do
    within('#submissions') { click_link "Join a team" }
    click_link "Ask to join"
    click_button "Ask to be a mentor for #{available_team.name}"

    join_request = JoinRequest.last
    expect(current_path).to eq(mentor_join_request_path(join_request))
    expect(page).to have_content(join_request.joinable_name)
    expect(page).to have_content("Pending review")
  end
end
