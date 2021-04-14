class SubmissionToJudgeValidator
  def initialize(judge:, submission:)
    @judge = judge
    @submission = submission
  end

  def call
    validate_judge
  end

  private

  Result = Struct.new(:success?, :message, keyword_init: true)

  attr_reader :judge, :submission

  def validate_judge
    if judge.blank?
      Result.new(success?: false, message: {error: "This is not a judge account"})
    elsif judge.suspended?
      Result.new(success?: false, message: {error: "#{judge.account.email} is suspended"})
    elsif judge.scores.map(&:team_submission_id).include?(submission.id)
      Result.new(success?: false, message: {error: "#{judge.account.email} has already been assigned this submission"})
    else
      Result.new(success?: true, message: {success: "#{judge.account.email} can be assigned a submission"})
    end
  end
end
