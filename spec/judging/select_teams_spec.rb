require "spec_helper"
require "./app/judging/judging"

RSpec.describe "Selecting teams for judging" do
  it "returns no teams for no round active" do
    setting = double(:setting, judgingRound: 'no_round')
    judge = double(:judge, event: double(:is_virtual? => false))
    judging = Judging.new(judge, double, setting)

    expect(judging.teams).to be_empty
  end

  context "for quarterfinals" do

    before do
      Quarterfinal.open!
      Semifinal.close!
    end

    it "selects teams from the judge's event" do
      setting = double(:setting, judgingRound: 'quarterfinal')
      team = double(:team, :eligible? => true)
      event = double(:event, :is_virtual? => false, teams: [team])
      judge = double(:judge, event: event)

      judging = Judging.new(judge, double, setting)

      expect(judging.teams).to eq([team])
    end

    it "returns nothing for semifinalist judges" do
      setting = double(:setting, judgingRound: 'semifinal')
      team = double(:team, :eligible? => true)
      event = double(:event, :is_virtual? => false, teams: [team])
      judge = double(:judge, event: event, semifinals_judge?: true)

      judging = Judging.new(judge, double, setting)

      expect(judging.teams).to be_empty
    end

  end

  context "for semifinals" do
    let(:setting) { double(:setting, judgingRound: 'semifinal') }
    let(:team) { double(:team, :eligible? => true) }
    let(:team_list) { double(:Team, includes: double(is_semi_finalist: [team])) }

    before { Semifinal.open! }

    it "selects semifinals teams" do
      judge = double(:judge, event: double(:is_virtual? => false),
                             :semifinals_judge? => true)
      judging = Judging.new(judge, team_list, setting)
      expect(judging.teams).to eq([team])
    end

    it "returns nothing for non-semifinalist judges" do
      judge = double(:judge, event: double(:is_virtual? => false),
                             :semifinals_judge? => false)
      judging = Judging.new(judge, team_list, setting)
      expect(judging.teams).to be_empty
    end
  end
end
