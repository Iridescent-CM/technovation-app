require "spec_helper"
require "./app/scores/visible_scores"

RSpec.describe "Read visible scores" do
  it "sets rubrics  when the round's scores are visible" do
    setting = double(:setting, scoresVisible: ['quarterfinal', 'semifinal'])
    team = double(:team, name: 'team')

    expect(team).to receive('quarterfinal_rubrics')
    expect(team).to receive('semifinal_rubrics')
    VisibleScores.new(team, setting: setting)
  end

  it "sets rubrics to empty when scores are not visible" do
    setting = double(:setting, scoresVisible: [])
    teams = [double(:team, name: 'team')]

    scores = VisibleScores.new(teams, setting: setting)
    score = scores.first

    expect(score.rubrics).to be_empty
  end
end
