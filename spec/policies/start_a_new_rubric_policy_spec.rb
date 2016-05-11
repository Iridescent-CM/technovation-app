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

    context "for judge roles" do
      let(:judge) { TestJudge.new(judging_region_id: 1,
                                  event_id: 1,
                                  conflict_region_ids: [2]) }

      subject(:policy) { RubricPolicy.new(judge, rubric, setting) }

      it "passes judging tests" do
        skip
        test_valid_judge(policy)
        test_judge_region_policies(policy)
        test_judge_event_policies(policy)
      end
    end

    context "for judging enabled" do
      let(:team_requests) { double(:team_requests_relation) }
      let(:coach) { TestJudgingEnabled.new(judging_region_id: 1,
                                           event_id: 1,
                                           conflict_region_ids: [2],
                                           team_requests: team_requests) }

      subject(:policy) { RubricPolicy.new(coach, rubric, setting) }

      it "passes judging tests" do
        skip
        allow(team_requests).to receive(:where)
          .with(team_id: team.id)
          .and_return([])

        test_valid_judge(policy)
        test_judge_region_policies(policy)
        test_judge_event_policies(policy)
      end

      it "restricted against users assigned through a team request" do
        skip
        expect(team_requests).to receive(:where)
          .with(team_id: team.id)
          .and_return(['something'])

        expect(policy.new?).to be false
      end
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

  class TestJudgingEnabled < TestJudge
    def role
      'coach'
    end

    def judging?
      true
    end
  end
end
