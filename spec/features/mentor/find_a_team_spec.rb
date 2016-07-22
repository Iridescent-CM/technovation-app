require "rails_helper"

RSpec.feature "Mentors find a team" do
  scenario "browse nearby teams that don't have a mentor" do
    mentored_team = FactoryGirl.create(:team, :with_mentor, creator_in: "Chicago, IL, US")
    available_team = FactoryGirl.create(:team, creator_in: "Chicago, IL, US")
    faraway_team = FactoryGirl.create(:team, creator_in: "Los Angeles, CA, US")
    mentor = FactoryGirl.create(:mentor, city: "Chicago",
                                         state_province: "IL",
                                         country: "US")

    sign_in(mentor)

    click_link "My Teams"
    click_link "Browse available teams"

    expect(page).to have_css(".team_name", text: available_team.name)
    expect(page).not_to have_css(".team_name", text: mentored_team.name)
    expect(page).not_to have_css(".team_name", text: faraway_team.name)
  end
end
