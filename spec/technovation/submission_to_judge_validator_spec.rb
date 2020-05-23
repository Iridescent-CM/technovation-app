require "rails_helper"

RSpec.describe SubmissionToJudgeValidator do
  let(:validator_result) { SubmissionToJudgeValidator.new(judge: judge).call }
  let(:judge) { instance_double(JudgeProfile, account: account, suspended?: judge_suspended) }
  let(:account) { instance_double(Account, email: "judge345@alwaysbejudging.com") }
  let(:judge_suspended) { true }

  context "when a judge can be assigned another submission (not suspended and doesn't have another score in progress)" do
    let(:judge_suspended) { false }

    before do
      allow(judge).to receive_message_chain("scores.current_round.incomplete.any?").and_return(false)
    end

    it "returns successful" do
      expect(validator_result).to be_success
    end

    it "returns a success message" do
      expect(validator_result.message).to eq({ success: "#{judge.account.email} can be assigned a submission" })
    end
  end

  context "when a judge account doesn't exist" do
    let(:judge) { nil }

    it "does not return successful" do
      expect(validator_result).not_to be_success
    end

    it "returns a failure message" do
      expect(validator_result.message).to eq({ error: "This is not a judge account"})
    end
  end

  context "when a judge is suspended" do
    let(:judge_suspended) { true }

    it "does not return successful" do
      expect(validator_result).not_to be_success
    end

    it "returns a failure message" do
      expect(validator_result.message).to eq({ error: "#{judge.account.email} is suspended"})
    end
  end

  context "when a judge is not suspended, but has another score already in progress" do
    let(:judge_suspended) { false }
    before do
      allow(judge).to receive_message_chain("scores.current_round.incomplete.any?").and_return(true)
    end

    it "does not return successful" do
      expect(validator_result).not_to be_success
    end

    it "returns a failure message" do
      expect(validator_result.message).to eq({ error: "#{judge.account.email} already has a score in progress"})
    end
  end
end
