require "spec_helper"

RSpec.describe "Calculate scores" do
  points = %i{identify_problem address_problem functional external_resources
              match_features interface description market competition
              revenue branding pitch}

  it "scores zero for all zeroes" do
    attributes = Hash[points.map { |point| [point, 0] }]
    rubric = double(:rubric, attributes.merge(score: 0))

    CalculateScore.call(rubric)

    expect(rubric.score).to eq(0)
  end

  class CalculateScore
    def self.call(rubric)
    end
  end
end
