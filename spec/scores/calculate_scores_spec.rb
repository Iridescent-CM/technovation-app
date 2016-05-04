require "spec_helper"
require "ostruct"

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

  class CalculateScore
    class << self
      def call(rubric)
        rubric.score = scoring_attributes.inject(0) do |accumulator, attr|
          accumulator + rubric.send(attr)
        end
      end

      def scoring_attributes
        %i{identify_problem address_problem functional external_resources
           match_features interface description market competition
           revenue branding pitch}
      end
    end
  end

  class TestRubric < OpenStruct
  end
end
