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
      expect(page).to have_link("Attend an Event")
    end

    scenario "Toggled off" do
      SeasonToggles.select_regional_pitch_event="off"
      visit path
      expect(page).not_to have_link("Attend an Event")
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
    let(:user) { FactoryBot.create(:mentor) }
    let(:team) { FactoryBot.create(:team) }
    let(:sub) { FactoryBot.create(:submission, :junior) }
    let(:rpe) { FactoryBot.create(:rpe) }
    let(:path) { new_mentor_regional_pitch_event_selection_path }

    before do
      team.team_submissions << sub
      TeamRosterManaging.add(team, user)

      sign_in(user)
    end

    scenario "Toggled on" do
      SeasonToggles.select_regional_pitch_event="on"
      visit path
      expect(page).to have_button("Save changes")

      page.all(:css, "input[type='radio']").each do |radio|
        expect(radio[:disabled]).to be_nil
      end
    end

    scenario "Toggled off" do
      SeasonToggles.select_regional_pitch_event="off"
      visit path
      expect(page).not_to have_button("Save changes")

      page.all(:css, "input[type='radio']").each do |radio|
        expect(radio[:disabled]).to eq("disabled")
      end
    end
  end

  context "Mentor dashboard" do
    let(:user) { FactoryBot.create(:mentor) }
    let(:team) { FactoryBot.create(:team) }
    let(:sub) { FactoryBot.create(:submission, :junior) }
    let!(:rpe) { FactoryBot.create(:rpe) }
    let(:path) { mentor_dashboard_path(anchor: "pitch-events") }

    before do
      team.team_submissions << sub
      TeamRosterManaging.add(team, user)

      sign_in(user)
    end

    scenario "Toggled on" do
      skip "Rebuilding mentor dashboard: RPE selection not back yet"

      SeasonToggles.select_regional_pitch_event="on"
      visit path
      expect(page).to have_button("Save selection")

      ["virtual", rpe.id].each do |id|
        div = find("div#team_#{team.id}_event_info_#{id}")
        expect(div).to have_button("Select")
      end

      page.all(:css, "input[type='radio']").each do |radio|
        expect(radio[:disabled]).to be_nil
      end
    end

    scenario "Toggled off" do
      skip "Rebuilding mentor dashboard: RPE selection not back yet"

      SeasonToggles.select_regional_pitch_event="off"
      visit path
      expect(page).not_to have_button("Save changes")

      ["virtual", rpe.id].each do |id|
        div = find("div#team_#{team.id}_event_info_#{id}")
        expect(div).not_to have_button("Select")
      end

      page.all(:css, "input[type='radio']").each do |radio|
        expect(radio[:disabled]).to eq("disabled")
      end
    end
  end
end
