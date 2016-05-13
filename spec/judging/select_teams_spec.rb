require "spec_helper"
require "./app/models/judging"

RSpec.describe "Selecting teams for judging" do
  it "returns no teams for no round active" do
    setting = double(:setting, judgingRound: 'no_round')
    judge = double(:judge, home_country: 'US', event: double(:is_virtual? => false))
    judging = Judging.new(judge, double, setting)

    expect(judging.teams).to be_empty
  end

  context "for quarterfinals" do
    it "selects teams from the judge's event" do
      setting = double(:setting, judgingRound: 'quarterfinal')
      team = double(:team, judges: [],
                           :ineligible? => false,
                           :submission_eligible? => true,
                           country: 'US')
      event = double(:event, :is_virtual? => false, teams: [team])
      judge = double(:judge, home_country: 'US', event: event)

      judging = Judging.new(judge, double, setting)

      expect(judging.teams).to eq([team])
    end
  end

  context "for semifinals" do
    let(:team) { double(:team, judges: [],
                          :ineligible? => false,
                          :submission_eligible? => true,
                          country: 'US') }
    let(:team_list) { double(:Team, is_semi_finalist: [team]) }
    let(:setting) { double(:setting, judgingRound: 'semifinal') }

    it "selects semifinals teams" do
      judge = double(:judge, event: double(:is_virtual? => false),
                             home_country: 'US',
                             :semifinals_judge? => true)
      judging = Judging.new(judge, team_list, setting)
      expect(judging.teams).to eq([team])
    end

    it "returns nothing for non-semifinalist judges" do
      judge = double(:judge, event: double(:is_virtual? => false),
                             home_country: 'US',
                             :semifinals_judge? => false)
      judging = Judging.new(judge, team_list, setting)
      expect(judging.teams).to be_empty
    end
  end
end
