require "rails_helper"
require "./lib/remove_empty_teams"

RSpec.describe RemoveEmptyTeams do
  describe ".call" do
    it "only deletes empty teams" do
      empty_team = FactoryBot.create(:team)
      empty_team.memberships.destroy_all

      team_with_members = FactoryBot.create(:team) # has members by default

      RemoveEmptyTeams.call

      expect(empty_team.reload).to be_deleted
      expect(Team.all).to eq([team_with_members])
    end
  end
end
