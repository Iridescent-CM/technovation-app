require "spec_helper"
require "ostruct"
require "./app/services/calculate_score"

RSpec.describe "Calculate scores" do
  let(:points) { CalculateScore.scoring_attributes }

  it "scores zero for all zeroes" do
    attributes = Hash[points.map { |point| [point, 0] }]
    rubric = TestRubric.new(attributes)

    CalculateScore.call(rubric)

    expect(rubric.score).to eq(0)
  end

  it "scores one for all zeroes and a 1" do
    attributes = Hash[points.map { |point| [point, 0] }]
    rubric = TestRubric.new(attributes.merge(revenue: 1))

    CalculateScore.call(rubric)

    expect(rubric.score).to eq(1)
  end

  it "scores an extra 2 points when launched is true" do
    attributes = Hash[points.map { |point| [point, 0] }]
    rubric = TestRubric.new(attributes.merge(launched: true))

    CalculateScore.call(rubric)

    expect(rubric.score).to eq(2)
  end

  class TestRubric < OpenStruct
  end
end
