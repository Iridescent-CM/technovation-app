require "rails_helper"

RSpec.feature "Select regional pitch event toggles user controls" do
  before { SeasonToggles.judging_round = :off }

  context "Student dashboard" do
    let!(:rpe) { FactoryBot.create(:event, :chicago, :junior) }

    let(:sub) { FactoryBot.create(:submission, :chicago, :junior) }
    let(:path) { student_dashboard_path(anchor: "live-events") }

    before do
      sign_in(sub.team.students.sample)
    end

    scenario "Toggled on" do
      SeasonToggles.select_regional_pitch_event="on"
      visit path
      expect(page).to have_link("Select an Event")
    end

    scenario "Toggled off" do
      SeasonToggles.select_regional_pitch_event="off"
      visit path
      expect(page).not_to have_link("Select an Event")
    end
  end

  context "Judge dashboard" do
    let(:user) { FactoryBot.create(:judge, onboarded: true) }
    let(:rpe) { FactoryBot.create(:rpe) }
    let(:path) { judge_dashboard_path(anchor: "live-events") }

    before do
      rpe.judges << user
      sign_in(user)
    end

    scenario "Toggled on" do
      skip "Disabled while judging is being re-built"

      SeasonToggles.select_regional_pitch_event="on"
      visit path
      expect(page).to have_link("remove yourself from this event")
    end

    scenario "Toggled off" do
      skip "Disabled while judging is being re-built"

      SeasonToggles.select_regional_pitch_event="off"
      visit path
      expect(page).not_to have_link("remove yourself from this event")
    end
  end

  context "Judge regional pitch event page for judge's event" do
    let(:user) { FactoryBot.create(:judge) }
    let(:rpe) { FactoryBot.create(:rpe) }
    let(:path) { judge_regional_pitch_event_path(id: rpe.id) }

    before do
      rpe.judges << user
      sign_in(user)
    end

    scenario "Toggled on" do
      skip "Disabled while judging is being re-built"

      SeasonToggles.select_regional_pitch_event="on"
      visit path
      expect(page).to have_link("Remove yourself from this event")
    end

    scenario "Toggled off" do
      skip "Disabled while judging is being re-built"

      SeasonToggles.select_regional_pitch_event="off"
      visit path
      expect(page).not_to have_link("Remove yourself from this event")
    end
  end

  context "Judge regional pitch event page for different event" do
    let(:user) { FactoryBot.create(:judge) }
    let(:rpe) { FactoryBot.create(:rpe) }
    let(:path) { judge_regional_pitch_event_path(id: rpe.id) }

    before do
      sign_in(user)
    end

    scenario "Toggled on" do
      skip "Disabled while judging is being re-built"

      SeasonToggles.select_regional_pitch_event="on"
      visit path
      expect(page).to have_link("Select this event instead")
    end

    scenario "Toggled off" do
      skip "Disabled while judging is being re-built"

      SeasonToggles.select_regional_pitch_event="off"
      visit path
      expect(page).not_to have_link("Select this event instead")
    end
  end

  context "Mentor regional pitch event selection page" do
    let!(:rpe) { FactoryBot.create(:rpe, :junior, :chicago) }

    let(:mentor) { FactoryBot.create(:mentor) }
    let(:sub) { FactoryBot.create(:submission, :junior, :chicago) }
    let(:path) { mentor_regional_pitch_events_team_list_path }

    before do
      TeamRosterManaging.add(sub.team, mentor)
      sign_in(mentor)
    end

    scenario "Toggled on" do
      SeasonToggles.select_regional_pitch_event="on"
      visit path
      expect(page).to have_css(".button", text: "Select an Event")
    end

    scenario "Toggled off" do
      SeasonToggles.select_regional_pitch_event="off"
      visit path
      expect(page).not_to have_css(".button", text: "Select an Event")
    end
  end

  context "Mentor dashboard" do
    let(:user) { FactoryBot.create(:mentor) }
    let(:team) { FactoryBot.create(:team) }
    let(:sub) { FactoryBot.create(:submission, :junior) }
    let!(:rpe) { FactoryBot.create(:rpe) }
    let(:path) { mentor_dashboard_path }

    before do
      team.team_submissions << sub
      TeamRosterManaging.add(team, user)

      sign_in(user)
    end

    scenario "Toggled on" do
      SeasonToggles.select_regional_pitch_event="on"
      visit path
      expect(page).to have_css(".button", text: "Select Events")
    end

    scenario "Toggled off" do
      SeasonToggles.select_regional_pitch_event="off"
      visit path
      expect(page).not_to have_css(".button", text: "Select Events")
    end
  end
end
