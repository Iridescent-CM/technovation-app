require "rails_helper"

RSpec.describe SubmissionToJudgeAssigner do
  let(:submission_to_judge_assignor) do
    SubmissionToJudgeAssigner.new(submission: submission,
      judge: judge,
      validator: submission_to_judge_validator,
      score_questions: score_questions)
  end

  let(:submission) { instance_double(TeamSubmission) }
  let(:judge) { instance_double(JudgeProfile, account: account) }
  let(:account) { instance_double(Account, email: "judgejudy@abcjudges.com") }
  let(:submission_to_judge_validator) { class_double(SubmissionToJudgeValidator) }
  let(:score_questions) { class_double(Questions) }
  let(:assignor_result) { submission_to_judge_assignor.call }

  before do
    allow(submission_to_judge_validator).to receive_message_chain(:new, :call).and_return(validator_result)
    allow(score_questions).to receive(:new).with(judge, submission)
  end

  let(:validator_result) do
    double("validator_result",
      success?: validator_success,
      message: validator_message)
  end
  let(:validator_success) { false }
  let(:validator_message) { nil }

  context "when the validator is successful" do
    let(:validator_success) { true }

    it "assigns the submission to the judge (by initializing score questions)" do
      expect(score_questions).to receive(:new).with(judge, submission)

      submission_to_judge_assignor.call
    end

    it "returns a success message" do
      expect(assignor_result.message).to eq({
        success: "This submission was successfully assigned to #{judge.account.email}"
      })
    end
  end

  context "when the validator is unsuccessful" do
    let(:validator_success) { false }
    let(:validator_message) { "Something unsuccessful just happened" }

    it "returns the validator result" do
      expect(assignor_result).to eq(validator_result)
    end
  end
end
