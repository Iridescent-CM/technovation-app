require "rails_helper"

describe SubmissionPublisher do
  let(:submission_publisher) do
    SubmissionPublisher.new(submission: submission, logger: logger)
  end
  let(:submission) do
    double(TeamSubmission,
      id: 10,
      app_name: "Fox in a Box",
      only_needs_to_submit?: only_needs_to_submit)
  end
  let(:only_needs_to_submit) { false }
  let(:logger) { instance_double(ActiveSupport::Logger, error: true) }

  before do
    allow(submission).to receive(:publish!)
  end

  context "when a submission only needs to submit" do
    let(:only_needs_to_submit) { true }

    it "publishes the submission" do
      expect(submission).to receive(:publish!)

      submission_publisher.call
    end

    it "returns a success result" do
      expect(submission_publisher.call.success?).to eq(true)
    end
  end

  context "when a submission needs more than just submitting" do
    let(:only_needs_to_submit) { false }

    it "does not publish the submission" do
      expect(submission).not_to receive(:publish!)

      submission_publisher.call
    end

    it "logs an error" do
      expect(logger).to receive(:error).with("[SUBMISSION PUBLISHER SERVICE] Could not publish submission #{submission.id} #{submission.app_name}")

      submission_publisher.call
    end

    it "does not return a success result" do
      expect(submission_publisher.call.success?).to eq(false)
    end
  end
end
