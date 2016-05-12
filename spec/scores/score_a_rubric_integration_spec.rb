require "rails_helper"

RSpec.describe "Score an actual rubric" do
  before do
    Quarterfinal.open!
    Semifinal.open!
    Final.open!
  end

  it "scores correctly for a given rubric" do
    rubric = FactoryGirl.create(:rubric,
                                identify_problem: 3,
                                address_problem: 0,
                                functional: 5,
                                external_resources: 1,
                                match_features: 1,
                                interface: 0,
                                description: 3,
                                market: 0,
                                competition: 0,
                                revenue: 0,
                                branding: 0,
                                pitch: 0)

    expect(rubric.score).to eq(13)
  end

  it "scores a launched rubric correctly" do
    rubric = FactoryGirl.create(:rubric,
                                launched: true,
                                identify_problem: 3,
                                address_problem: 0,
                                functional: 5,
                                external_resources: 1,
                                match_features: 1,
                                interface: 0,
                                description: 3,
                                market: 0,
                                competition: 0,
                                revenue: 0,
                                branding: 0,
                                pitch: 0)

    expect(rubric.score).to eq(15)
  end
end
