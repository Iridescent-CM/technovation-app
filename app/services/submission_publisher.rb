class SubmissionPublisher
  def initialize(submission:, logger: Rails.logger)
    @submission = submission
    @logger = logger
  end

  def call
    if submission.only_needs_to_submit?
      submission.publish!

      Result.new(success?: true, message: {success: "Successfully published submission #{submission.id} #{submission.app_name}"})
    else
      error_message = "Could not publish submission #{submission.id} #{submission.app_name}"

      logger.error("[SUBMISSION PUBLISHER SERVICE] #{error_message}")

      Result.new(success?: false, message: {error: error_message})
    end
  end

  private

  Result = Struct.new(:success?, :message, keyword_init: true)

  attr_reader :submission, :logger
end
