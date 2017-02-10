require "rails_helper"

RSpec.feature "Mentors find a team" do
  let!(:available_team) { FactoryGirl.create(:team) } # Creator is in Chicago

  before do
    mentor = FactoryGirl.create(:mentor) # City is Chicago
    sign_in(mentor)
  end

  scenario "browse nearby teams" do
    mentored_team = FactoryGirl.create(:team, :with_mentor) # Creator is in Chicago
    faraway_team = FactoryGirl.create(:team, creator_in: "Los Angeles")

    click_link "Join a team"

    expect(page).to have_css(".team-search-result__name", text: available_team.name)
    expect(page).to have_css(".team-search-result__name", text: mentored_team.name)
    expect(page).not_to have_css(".team-search-result__name", text: faraway_team.name)
  end

  scenario "request to join a team" do
    click_link "Join a team"
    click_link "View Team"
    click_button "Request to be a mentor for #{available_team.name}"

    join_request = JoinRequest.last
    expect(current_path).to eq(mentor_join_request_path(join_request))
    expect(page).to have_content(join_request.joinable_name)
    expect(page).to have_content("Pending review")
  end
end
