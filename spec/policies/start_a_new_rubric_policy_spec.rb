require "spec_helper"
require "./spec/policies/judging_policy_tests"
require "./app/services/check_judging_policy"
require "./app/policies/rubric_policy"
require "ostruct"

RSpec.describe "Policy to start a new rubric" do
  describe "#new?" do
    include JudgingPolicyTests

    let(:setting) { double(:setting, :anyJudgingRoundActive? => true) }

    let(:team) { double(:team, id: 1, region_id: 1, event_id: 1) }

    let(:rubric) { double(:rubric, team: team) }

    it "requires the http referer to be the rubrics page" do
      user = double(:user_context, user: TestJudge.new, referer: 'bad')
      policy = RubricPolicy.new(user, rubric, setting)
      expect(policy.new?).to be false

      user = double(:user_context, user: TestJudge.new,
                                   referer: 'http://example.com/rubrics')
      policy = RubricPolicy.new(user, rubric, setting)
      expect(policy.new?).to be true
    end
  end

  class TestUser < OpenStruct
    def can_judge?(team = nil)
      CheckJudgingPolicy.call(self, team)
    end
  end

  class TestJudge < TestUser
    def role
      'judge'
    end
  end
end
