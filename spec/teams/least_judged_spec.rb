require "rails_helper"

RSpec.describe "Select the least judged teams" do
  it "selects the least judged teams" do
    Quarterfinal.open! # why?

    judged_lots = create(:team)
    judged_little = create(:team)
    judged_little_also = create(:team)

    2.times { create(:rubric, team: judged_lots) }
    create(:rubric, team: judged_little)
    create(:rubric, team: judged_little_also)

    teams = [judged_little, judged_lots, judged_little_also]

    expect(Team.least_judged(teams)).to match_array(
      [judged_little, judged_little_also]
    )
  end
end
