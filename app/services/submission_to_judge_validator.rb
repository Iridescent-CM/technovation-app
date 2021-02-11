class SubmissionToJudgeValidator
  def initialize(judge:)
    @judge = judge
  end

  def call
    validate_judge
  end

  private

  Result = Struct.new(:success?, :message, keyword_init: true)

  attr_reader :judge

  def validate_judge
    if judge.blank?
      Result.new(success?: false, message: {error: "This is not a judge account"})
    elsif judge.suspended?
      Result.new(success?: false, message: {error: "#{judge.account.email} is suspended"})
    elsif judge.scores.current_round.incomplete.any?
      Result.new(success?: false, message: {error: "#{judge.account.email} already has a score in progress"})
    else
      Result.new(success?: true, message: {success: "#{judge.account.email} can be assigned a submission"})
    end
  end
end
