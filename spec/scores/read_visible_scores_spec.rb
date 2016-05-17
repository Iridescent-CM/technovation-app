require "spec_helper"
require "./app/models/visible_scores"

RSpec.describe "Read visible scores" do
  it "sets rubrics  when the round's scores are visible" do
    stages = { 'quarterfinal' => 0 }
    setting = double(:setting, scoresVisible: ['quarterfinal'])
    rubric_list = double(:rubric_list, stages: stages)
    rubrics = double(:rubrics)
    teams = [double(:team, name: 'team', rubrics: rubric_list)]
    user = double(:user, teams: teams)

    expect(rubric_list).to receive(:where)
      .with(stage: [0])
      .and_return(rubrics)

    scores = VisibleScores.new(user, rubric_list, setting)
    score = scores.first

    expect(score.rubrics).to eq(rubrics)
  end

  it "sets rubrics to empty when scores are not visible" do
    stages = { 'quarterfinal' => 0 }
    setting = double(:setting, scoresVisible: [])
    rubric_list = double(:rubric_list, stages: stages)
    rubrics = double(:rubrics)
    teams = [double(:team, name: 'team', rubrics: rubric_list)]
    user = double(:user, teams: teams)

    expect(rubric_list).to receive(:where)
      .with(stage: [])
      .and_return([])

    scores = VisibleScores.new(user, rubric_list, setting)
    score = scores.first

    expect(score.rubrics).to be_empty
  end
end
