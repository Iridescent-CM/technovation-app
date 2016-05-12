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
    let(:team1) { create(:team, is_semi_finalist: true) }
    let(:team2) { create(:team, is_semi_finalist: false) }

    it "selects semifinals teams" do

      setting = double
      judge = double(:judge, semifinals_judge?: true)
      round = Semifinal.new

      judging = Judging.new(judge, setting)

      expect(judging.teams(round)).to eq([team1])
    end
  end

end
