require "rails_helper"

RSpec.describe SubmissionToJudgeValidator do
  let(:validator_result) { SubmissionToJudgeValidator.new(judge: judge, submission: submission).call }
  let(:judge) { instance_double(JudgeProfile, account: account, suspended?: judge_suspended) }
  let(:account) { instance_double(Account, email: "judge345@alwaysbejudging.com") }
  let(:judge_suspended) { false }
  let(:submission) { instance_double(TeamSubmission, id: 12) }

  context "when a judge can be assigned another submission (i.e. not suspended and not already assigned to the submission" do
    let(:judge_suspended) { false }

    before do
      allow(judge).to receive_message_chain("scores").and_return([])
    end

    it "returns successful" do
      expect(validator_result).to be_success
    end

    it "returns a success message" do
      expect(validator_result.message).to eq({success: "#{judge.account.email} can be assigned a submission"})
    end
  end

  context "when a judge account doesn't exist" do
    let(:judge) { nil }

    it "does not return successful" do
      expect(validator_result).not_to be_success
    end

    it "returns a failure message" do
      expect(validator_result.message).to eq({error: "This is not a judge account"})
    end
  end

  context "when a judge is suspended" do
    let(:judge_suspended) { true }

    it "does not return successful" do
      expect(validator_result).not_to be_success
    end

    it "returns a failure message" do
      expect(validator_result.message).to eq({error: "#{judge.account.email} is suspended"})
    end
  end

  context "when a judge has already been assigned to the submission" do
    before do
      allow(judge).to receive_message_chain("scores").and_return(already_assigned_submissions)
    end

    let(:already_assigned_submissions) { [instance_double(SubmissionScore, team_submission_id: submission.id)] }

    it "does not return successful" do
      expect(validator_result).not_to be_success
    end

    it "returns a failure message" do
      expect(validator_result.message).to eq({error: "#{judge.account.email} has already been assigned this submission"})
    end
  end
end
