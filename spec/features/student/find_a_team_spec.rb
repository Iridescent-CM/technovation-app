require "rails_helper"

RSpec.feature "Students find a team" do
  before { SeasonToggles.team_building_enabled! }

  let!(:available_team) { FactoryGirl.create(:team, :geocoded) } # Default is in Chicago

  before do
    student = FactoryGirl.create(:student, :geocoded, not_onboarded: true) # City is Chicago
    sign_in(student)
  end

  scenario "browse nearby teams" do
    team = FactoryGirl.create(:team, :geocoded) # Default is in Chicago
    faraway_team = FactoryGirl.create(
      :team,
      :geocoded,
      city: "Los Angeles",
      state_province: "CA"
    )

    click_link "Join a team"

    expect(page).to have_css(".search-result-head", text: team.name)
    expect(page).not_to have_css(".search-result-head", text: faraway_team.name)
  end

  scenario "request to join a team" do
    click_link "Join a team"
    click_link "Ask to join"
    click_button "Ask to join #{available_team.name}"

    join_request = JoinRequest.last
    expect(current_path).to eq(new_student_join_request_path)
    expect(page).to have_content(join_request.joinable_name)
    expect(page).to have_content("You have asked to join")
  end
end
