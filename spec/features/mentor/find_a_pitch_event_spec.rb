require "rails_helper"

RSpec.feature "Mentor finds a pitch event" do
  context "Mentor is not onboarded" do
    let(:mentor) { FactoryBot.create(:mentor, :onboarding) }

    before do
      sign_in(mentor)
    end

    scenario "Select pitch events toggle is ON" do
      SeasonToggles.select_regional_pitch_event = "on"
      visit mentor_regional_pitch_events_finder_path

      expect(page).to have_content("Please complete mentor onboarding to view live pitch events in your region.")
      expect(page).not_to have_link("Select Events")
    end

    scenario "Select pitch events toggle is OFF" do
      SeasonToggles.select_regional_pitch_event = "off"
      visit mentor_regional_pitch_events_finder_path

      expect(page).to have_content("Please complete mentor onboarding to view live pitch events in your region.")
      expect(page).not_to have_link("Select Events")
    end
  end

  context "Mentor is onboarded" do
    let!(:rpe) { FactoryBot.create(:rpe, :junior, :chicago) }
    let(:mentor) { FactoryBot.create(:mentor, :onboarded) }
    let(:team) { FactoryBot.create(:team) }
    let(:submission) { FactoryBot.create(:submission, :junior, :chicago) }

    before do
      team.team_submissions << submission
      TeamRosterManaging.add(team, mentor)

      sign_in(mentor)
    end

    scenario "Select pitch events toggle is ON" do
      SeasonToggles.select_regional_pitch_event = "on"
      visit mentor_regional_pitch_events_finder_path

      expect(page).to have_link("Select Events")
      click_link "Select Events"

      expect(page).to have_content("There is 1 regional pitch event that #{team.name} can attend.")
      click_link "Select an Event"
      expect(page).to have_content(rpe.name)
    end

    scenario "Select pitch events toggle is OFF" do
      SeasonToggles.select_regional_pitch_event = "off"
      visit mentor_regional_pitch_events_finder_path

      expect(page).to have_content("Selecting an event is not available right now.")
      expect(page).not_to have_link("Select Events")
    end
  end
end