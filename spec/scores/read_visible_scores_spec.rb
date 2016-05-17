require "spec_helper"
require "./app/models/visible_scores"

RSpec.describe "Read visible scores" do
  it "sets rubrics  when the round's scores are visible" do
    setting = double(:setting, scoresVisible: ['quarterfinal', 'semifinal'])
    rubric = double(:rubric)
    team = double(:team, name: 'team')

    expect(team).to receive('quarterfinal_rubrics')
      .and_return([rubric])

    expect(team).to receive('semifinal_rubrics')
      .and_return([rubric])

    scores = VisibleScores.new(team, setting)
    score = scores.first

    expect(score.rubrics).to eq([rubric, rubric])
  end

  it "sets rubrics to empty when scores are not visible" do
    setting = double(:setting, scoresVisible: [])
    teams = [double(:team, name: 'team')]

    scores = VisibleScores.new(teams, setting)
    score = scores.first

    expect(score.rubrics).to be_empty
  end
end
