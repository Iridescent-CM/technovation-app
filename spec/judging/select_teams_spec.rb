require "spec_helper"
require "./app/models/judging"

RSpec.describe "Selecting teams for judging" do
  context "for quarterfinals" do
    it "selects teams from the judge's event" do
      setting = double
      team = double
      event = double(:event, teams: [team])
      judge = double(:judge, event: event)

      judging = Judging.new(judge, setting)

      expect(judging.teams(:quarterfinal)).to eq([team])
    end
  end
end
