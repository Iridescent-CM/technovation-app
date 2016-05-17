require "rails_helper"

RSpec.describe "Protect rubrics from fraud" do
  before { Semifinal.open! }

  it "defaults nil stage to current round" do
    user = create(:user, :judge, semifinals_judge: true)
    team = create(:team, :eligible, is_semi_finalist: true)

    rubric = create(:rubric, team: team, user: user)

    expect(rubric.reload.stage).to eq('semifinal')
  end

  it "doesn't allow final setting for non finalists" do
    user = create(:user, :judge, semifinals_judge: true)
    team = create(:team, :eligible, is_semi_finalist: true, is_finalist: false)

    rubric = create(:rubric, team: team, user: user, stage: Rubric.stages[:final])

    expect(rubric.reload.stage).to eq('semifinal')
  end

  it "doesn't allow semifinal setting for non semi finalists" do
    Semifinal.close!
    Quarterfinal.open!

    user = create(:user, :judge, semifinals_judge: true)
    team = create(:team, :eligible, is_semi_finalist: false, is_finalist: false)

    rubric = create(:rubric, team: team, user: user, stage: Rubric.stages[:semifinal])

    expect(rubric.reload.stage).to eq('quarterfinal')
  end

  it "doesn't allow the wrong judge to score in the wrong round" do
    user = create(:user, :judge, semifinals_judge: false)
    team = create(:team, :eligible, is_semi_finalist: true, is_finalist: false)

    rubric = create(:rubric, team: team, user: user, stage: Rubric.stages[:semifinal])

    expect(rubric.reload.stage).to be_nil
  end
end

