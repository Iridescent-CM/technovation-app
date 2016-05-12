require "spec_helper"
require "./app/models/judging"

RSpec.describe "Selecting teams for judging" do
  context "for quarterfinals" do
    it "selects teams from the judge's event" do
      setting = double
      team = double
      event = double(:event, teams: [team])
      judge = double(:judge, event: event)
      round = Quarterfinal.new

      judging = Judging.new(judge, setting)

      expect(judging.teams(round)).to eq([team])
    end
  end

  context "for semifinals" do
    let(:team1) { double(:team, is_semi_finalist: true) }

    before do
      allow(Team).to receive(:is_semi_finalist).and_return([team1])
    end

    it "selects semifinals teams" do

      setting = double
      team2 = double(:team, is_semi_finalist: false)
      judge = double(:judge, semifinals_judge?: true)
      round = Semifinal.new

      judging = Judging.new(judge, setting)

      expect(judging.teams(round)).to eq([team1])
    end
  end
end
