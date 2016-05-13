require "rails_helper"

RSpec.describe "Teams eligible for judging" do
  let(:judge) { create(:user, :judge) }
  let(:team) { create(:team, :eligible) }

  before do
    allow(Setting).to receive(:cutoff) { Date.yesterday }
    Quarterfinal.open!
  end

  it "is not eligible if the judge has judged them" do
    create(:rubric, team: team, user: judge)
    expect(team.eligible?(judge)).to be false
  end

  it "is eligible if the judge has not judged them" do
    team.rubrics.destroy
    expect(team.eligible?(judge)).to be true
  end

  it "is not eligible if there are not enough students" do
    add_members_to_team(team, 0)
    expect(team.eligible?(judge)).to be false
  end

  it "is eligible if there are 1 to 5 students" do
    add_members_to_team(team, (1..5).to_a.sample)
    expect(team.eligible?(judge)).to be true
  end

  it "is not eligible if there are too many students" do
    add_members_to_team(team, 6)
    expect(team.eligible?(judge)).to be false
  end

  it "is not eligible if the submission isn't eligible" do
    team.code = nil
    expect(team.eligible?(judge)).to be false
  end

  def add_members_to_team(team, num)
    team.team_requests.clear

    num.times do
      user = create(:user, :student)
      team.team_requests.create!(approved: true, user: user)
    end
  end
end
