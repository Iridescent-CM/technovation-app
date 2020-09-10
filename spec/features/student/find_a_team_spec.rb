require "rails_helper"

RSpec.feature "Students find a team" do
  let(:day_before_qfs) { ImportantDates.quarterfinals_judging_begins - 1.day }
  let(:current_season) { Season.new(day_before_qfs.year) }

  before { allow(Season).to receive(:current).and_return(current_season) }
  before { SeasonToggles.team_building_enabled! }

  let!(:available_team) { FactoryBot.create(:team, :geocoded) }
    # Default is in Chicago

  before do
    student = FactoryBot.create(:student, :geocoded, not_onboarded: true)
      # City is Chicago
    sign_in(student)
  end

  scenario "browse nearby teams" do
    team = FactoryBot.create(:team, :geocoded) # Default is in Chicago

    faraway_team = FactoryBot.create(
      :team,
      :geocoded,
      city: "Los Angeles",
      state_province: "CA"
    )

    within(".navigation") { click_link "Find a team" }

    expect(page).to have_css(".search-result-head", text: team.name)
    expect(page).not_to have_css(".search-result-head", text: faraway_team.name)
  end

  scenario "request to join a team" do
    Timecop.freeze(day_before_qfs) do
      within (".navigation") { click_link "Find a team" }
      click_link "View more details"
      click_button "Ask to join #{available_team.name}"

      join_request = JoinRequest.last

      expect(current_path).to eq(student_dashboard_path)
      expect(page).to have_content(join_request.team_name)
      expect(page).to have_content("You have asked to join")
    end
  end

  scenario "onboarded student sees pending requests" do
    Timecop.freeze(day_before_qfs) do
      sign_out

      onboarded = FactoryBot.create(:student, :geocoded)

      sign_in(onboarded)

      within(".navigation") { click_link "Find a team" }

      click_link "View more details"
      click_button "Ask to join #{available_team.name}"

      join_request = JoinRequest.last

      expect(current_path).to eq(student_dashboard_path)
      expect(page).to have_content(join_request.team_name)
      expect(page).to have_content("You have asked to join")
    end
  end
end
