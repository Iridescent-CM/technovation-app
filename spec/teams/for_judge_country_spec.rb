require "rails_helper"

RSpec.describe "Select teams based on judge's country" do
  before do
    allow(Setting).to receive(:cutoff) { Date.yesterday }
  end

  it "selects brazilian only for brazilian judges" do
    judge = create(:user, :judge, home_country: 'BR')
    team = create(:team, :eligible, country: 'US')
    expect(team.eligible?(judge)).to be false
  end

  it "selects non-brazilian only for non-brazilian judges" do
    judge = create(:user, :judge, home_country: 'US')
    team = create(:team, :eligible, country: 'BR')
    expect(team.eligible?(judge)).to be false
  end
end
