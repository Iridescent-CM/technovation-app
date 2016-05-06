require "spec_helper"
require "./app/services/check_judging_policy"
require "./app/policies/rubric_policy"
require "ostruct"

RSpec.describe "Policy to start a new rubric" do
  describe "#new?" do
    let(:setting) { double(:setting, :anyJudgingRoundActive? => true) }

    let(:team) { double(:team, id: 1, region_id: 1, event_id: 1) }

    let(:rubric) { double(:rubric, team: team) }

    context "for judge roles" do
      let(:judge) { TestJudge.new(judging_region_id: 1,
                                  event_id: 1,
                                  conflict_region_id: 2) }

      subject(:policy) { RubricPolicy.new(judge, rubric, setting) }

      it "is true for a valid judge" do
        expect(policy.new?).to be true
      end

      it "must be for a team in their judging region" do
        judge.judging_region_id = 2
        expect(policy.new?).to be false
      end

      it "cannot be for a team in their conflict region" do
        judge.conflict_region_id = 1
        expect(policy.new?).to be false
      end

      it "must be in the same event as the team" do
        judge.event_id = 2
        expect(policy.new?).to be false
      end
    end

    context "for judging enabled" do
      it "restricted against users assigned through a team request" do
        team_request = double(:team_request)
        team_requests = double(:team_requests_relation)
        coach = TestJudgingEnabled.new(team_requests: team_requests)
        policy = RubricPolicy.new(coach, rubric, setting)

        expect(team_requests).to receive(:where)
          .with(team_id: team.id)
          .and_return([team_request])

        expect(policy.new?).to be false
      end

      it "will pass for coaches without the team request" do
        team_requests = double(:team_requests_relation)
        coach = TestJudgingEnabled.new(team_requests: team_requests)
        policy = RubricPolicy.new(coach, rubric, setting)

        expect(team_requests).to receive(:where)
          .with(team_id: team.id)
          .and_return([])

        expect(policy.new?).to be true
      end
    end
  end

  class TestUser < OpenStruct
    def can_judge?(team)
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
