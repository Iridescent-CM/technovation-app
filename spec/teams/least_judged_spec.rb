require "rails_helper"

RSpec.describe "Select the least judged teams" do
  before do
    Season.open!
  end

  it "selects the least judged teams" do
    Quarterfinal.open!

    judged_lots = create(:team)
    judged_little = create(:team)
    judged_little_also = create(:team)

    2.times { create(:rubric, team: judged_lots) }
    create(:rubric, team: judged_little)
    create(:rubric, team: judged_little_also)

    teams = [judged_lots, judged_little, judged_little_also]

    expect(Team.least_judged(teams)).to match_array(
      [judged_little, judged_little_also]
    )
  end

  it "selects the least judged teams in the current judging round" do
    Quarterfinal.close!
    Semifinal.open!

    judged_last_round = create(:team, is_semi_finalist: true)
    judged_this_round = create(:team, is_semi_finalist: true)
    judged_this_round_also = create(:team, is_semi_finalist: true)

    2.times { create(:rubric, team: judged_last_round, stage: Rubric.stages[:quarterfinal]) }
    create(:rubric, team: judged_this_round, stage: Rubric.stages[:semifinal])
    create(:rubric, team: judged_this_round_also, stage: Rubric.stages[:semifinal])

    teams = [judged_last_round, judged_this_round_also, judged_this_round]

    expect(Team.least_judged(teams)).to eq([judged_last_round])
  end
end
