require "rails_helper"

RSpec.describe BulkDataProcessors::AssignTeamsToRegionalPitchEvent do
  let(:assign_teams_to_regional_pitch_event_service) do
    BulkDataProcessors::AssignTeamsToRegionalPitchEvent.new(regional_pitch_event:,
      team_ids:)
  end

  let(:regional_pitch_event) { FactoryBot.create(:regional_pitch_event) }
  let(:team_ids) { [team_1.id, team_2.id, team_3.id] }
  let(:team_1) { FactoryBot.create(:team, :submitted) }
  let(:team_2) { FactoryBot.create(:team, :submitted) }
  let(:team_3) { FactoryBot.create(:team, :submitted) }

  it "assigns teams to the RPE" do
    assign_teams_to_regional_pitch_event_service.call

    expect(regional_pitch_event.teams.map(&:name)).to include(team_1.name)
    expect(regional_pitch_event.teams.map(&:name)).to include(team_2.name)
    expect(regional_pitch_event.teams.map(&:name)).to include(team_3.name)
  end

  context "when a team id doesn't exist" do
    before do
      team_1.id = 500_000
    end

    it "doesn't add the team to the RPE" do
      result = assign_teams_to_regional_pitch_event_service.call

      expect(regional_pitch_event.teams).not_to include(team_1)
      expect(result.results).to include("Could not find team with ID: #{team_1.id}")
    end
  end

  context "when a team is not in the current season" do
    before do
      team_1.update(seasons: [2015])
    end

    it "doesn't add the team to the RPE" do
      result = assign_teams_to_regional_pitch_event_service.call

      expect(regional_pitch_event.teams).not_to include(team_1)
      expect(result.results).to include("#{team_1.name} is not a part of the current season")
    end
  end

  context "when a team does not have a submission" do
    let(:team_1) { FactoryBot.create(:team) }

    it "doesn't add the team to the RPE" do
      result = assign_teams_to_regional_pitch_event_service.call

      expect(regional_pitch_event.teams).not_to include(team_1)
      expect(result.results).to include("#{team_1.name} does not have a submission")
    end
  end

  context "when a team is already assigned to this RPE" do
    before do
      team_1.events << regional_pitch_event
    end

    it "doesn't reassign the team to the RPE" do
      expect(regional_pitch_event.teams).to include(team_1)

      result = assign_teams_to_regional_pitch_event_service.call

      expect(regional_pitch_event.teams.count).to eq(team_ids.length)
      expect(result.results).to include("#{team_1.name} has already been assigned to this event")
    end
  end

  context "when a team is assigned to another RPE" do
    let(:team_1) { FactoryBot.create(:team, :not_live_event_eligible) }

    it "doesn't add the team to this RPE" do
      result = assign_teams_to_regional_pitch_event_service.call

      expect(regional_pitch_event.teams).not_to include(team_1)
      expect(result.results).to include("#{team_1.name} is already assigned to another event")
    end
  end

  context "when a team belongs to a different division than the RPE's division" do
    before do
      team_1.update(division: Division.beginner)
    end

    it "doesn't add the team to the RPE" do
      result = assign_teams_to_regional_pitch_event_service.call

      expect(regional_pitch_event.teams).not_to include(team_1)
      expect(result.results.first).to include("#{team_1.name} is not in the correct division for this event")
    end
  end
end
