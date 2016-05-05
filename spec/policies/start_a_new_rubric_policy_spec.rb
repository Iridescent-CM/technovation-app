require "spec_helper"
require "./app/policies/rubric_policy"
require "ostruct"

RSpec.describe "Policy to start a new rubric" do
  describe "#new?" do
    it "is restricted against judges in conflicted regions" do
      team = double(:team, region_id: 1)
      rubric = double(:rubric, team: team)
      setting = double(:setting, :anyJudgingRoundActive? => true)

      judge = TestJudge.new(conflict_region_id: 1)

      policy = RubricPolicy.new(judge, rubric, setting)

      expect(policy.new?).to be false
    end
  end

  class TestJudge < OpenStruct
    def can_judge?(team)
      (role == 'judge' || judging?) &&
        conflict_region_id != team.region_id
    end

    def role
      'judge'
    end

    def judging?
      true
    end
  end
end
