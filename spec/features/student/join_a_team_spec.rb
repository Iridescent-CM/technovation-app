require "rails_helper"

RSpec.feature "Students find a team" do
  let(:day_before_qfs) { ImportantDates.quarterfinals_judging_begins - 1.day }
  let(:current_season) { Season.new(day_before_qfs.year) }

  before { allow(Season).to receive(:current).and_return(current_season) }
  before { SeasonToggles.team_building_enabled! }

  let!(:available_team) { FactoryBot.create(:team, :geocoded) }
  # Default is in Chicago
  let(:student) { FactoryBot.create(:student, :geocoded) }
  # City is Chicago

  before do
    sign_in(student)
  end

  scenario "request to join a team" do
    Timecop.freeze(day_before_qfs) do
      within (".sub-nav-wrapper") { click_link "Find a team" }
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
      within(".sub-nav-wrapper") { click_link "Find a team" }

      click_link "View more details"
      click_button "Ask to join #{available_team.name}"

      join_request = JoinRequest.last

      visit student_dashboard_path(anchor: "/find-team")

      expect(current_path).to eq(student_dashboard_path)
      expect(page).to have_content(join_request.team_name.titleize)
      expect(page).to have_content("You have asked to join")
    end
  end

  scenario "cancel a join request", js: true do
    Timecop.freeze(day_before_qfs) do
      within(".sub-nav-wrapper") { click_link "Find a team" }
      click_link "View more details"
      click_button "Ask to join #{available_team.name}"

      join_request = JoinRequest.last

      visit student_dashboard_path(anchor: "/find-team")

      within("#join_request_#{join_request.id}") { click_link "Cancel my request" }
      click_button "Yes, do it"

      expect(page).to have_content("You have cancelled your request")
      within("#join-requests") { expect(page).not_to have_content(available_team.name) }
    end
  end
end
