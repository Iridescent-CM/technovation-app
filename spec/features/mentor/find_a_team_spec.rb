require "rails_helper"

RSpec.feature "Mentors find a team" do
  let!(:available_team) { FactoryGirl.create(:team, creator_in: "Chicago, IL, US") }

  before do
    mentor = FactoryGirl.create(:mentor, city: "Chicago",
                                         state_province: "IL",
                                         country: "US")

    sign_in(mentor)

    click_link "My teams"
  end

  scenario "browse nearby teams that don't have a mentor" do
    mentored_team = FactoryGirl.create(:team, :with_mentor, creator_in: "Chicago, IL, US")
    faraway_team = FactoryGirl.create(:team, creator_in: "Los Angeles, CA, US")

    click_link "Browse available teams"

    expect(page).to have_css(".team_name", text: available_team.name)
    expect(page).not_to have_css(".team_name", text: mentored_team.name)
    expect(page).not_to have_css(".team_name", text: faraway_team.name)
  end

  scenario "request to join a team" do
    click_link "Browse available teams"
    click_link available_team.name
    click_button "Request to be a mentor for #{available_team.name}"

    join_request = JoinRequest.last
    expect(current_path).to eq(mentor_join_request_path(join_request))
    expect(page).to have_content(join_request.joinable_name)
    expect(page).to have_content("Pending review")
  end

  scenario "Browse requests" do
    click_link "Browse available teams"
    click_link available_team.name
    click_button "Request to be a mentor for #{available_team.name}"

    click_link "My requests"
    join_request = JoinRequest.last
    expect(page).to have_css('table', text: join_request.joinable_name)
    expect(page).to have_content("Pending review")
  end
end
