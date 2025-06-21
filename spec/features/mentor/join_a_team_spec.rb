require "rails_helper"

RSpec.feature "Mentors join a team" do
  let(:day_before_qfs) { ImportantDates.quarterfinals_judging_begins - 1.day }
  let(:current_season) { Season.new(day_before_qfs.year) }

  before { allow(Season).to receive(:current).and_return(current_season) }
  before { SeasonToggles.team_building_enabled! }

  let!(:available_team) { FactoryBot.create(:team, :geocoded) }
  # Default is in Chicago

  let(:mentor) { FactoryBot.create(:mentor, :onboarded, :geocoded) } # City is Chicago

  before {
    sign_in(mentor)
    visit mentor_team_builder_path
  }

  scenario "request to join a team" do
    Timecop.freeze(day_before_qfs) do
      click_link "Find a team"

      click_link "View more details"
      click_button "Ask to be a mentor for #{available_team.name}"

      join_request = JoinRequest.last

      expect(current_path).to eq(mentor_join_request_path(join_request))
      expect(page).to have_content(join_request.team_name)
      expect(page).to have_content(
        "You have requested to be a mentor for #{available_team.name}"
      )
    end
  end

  scenario "request to join the same team again, even if you deleted an earlier request" do
    Timecop.freeze(day_before_qfs) do
      join_request = JoinRequest.create!({
        requestor: mentor,
        team: available_team
      })

      join_request.deleted!

      click_link "Find a team"

      click_link "View more details"
      click_button "Ask to be a mentor for #{available_team.name}"

      expect(current_path).to eq(mentor_join_request_path(join_request))
      expect(page).to have_content("You have requested to be a mentor for #{available_team.name}")
    end
  end

  scenario "cancel a request to join a team", js: true do
    Timecop.freeze(day_before_qfs) do
      join_request = JoinRequest.create!({
        requestor: mentor,
        team: available_team
      })

      click_link "Pending Team Invites & Join Requests"
      within("#join_request_#{join_request.id}") { click_link "Cancel my request" }
      click_button "Yes, do it"

      expect(page).to have_content("You have cancelled your request")
      within("#find-team") { expect(page).not_to have_content(available_team.name) }
    end
  end
end
