require "spec_helper"
require "./app/policies/rubric_policy"

RSpec.describe "Policy to start a new rubric" do
  describe "#new?" do
    it "requires the http referer to be the rubrics page" do
      rubric = double(:rubric)
      setting = double(:setting, :anyJudgingRoundActive? => true)
      user = double(:user, :can_judge? => true)

      context = double(:user_context, user: user, referer: 'bad')
      policy = RubricPolicy.new(context, rubric, setting)
      expect(policy.new?).to be false

      context = double(:user_context, user: user,
                                      referer: 'http://example.com/rubrics')
      policy = RubricPolicy.new(context, rubric, setting)
      expect(policy.new?).to be true
    end
  end
end
