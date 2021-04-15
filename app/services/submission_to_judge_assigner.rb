class SubmissionToJudgeAssigner
  def initialize(submission:,
    judge:,
    validator: SubmissionToJudgeValidator,
    score_questions: Questions)

    @submission = submission
    @judge = judge
    @validator = validator
    @score_questions = score_questions
  end

  def call
    if validator_result.success?
      assign_submission_to_judge

      Result.new(success?: true, message: {success: "This submission was successfully assigned to #{judge.account.email}"})
    else
      validator_result
    end
  end

  private

  Result = Struct.new(:success?, :message, keyword_init: true)

  attr_reader :submission, :judge, :validator, :score_questions

  def validator_result
    @validator_result ||= validator.new(judge: judge, submission: submission).call
  end

  def assign_submission_to_judge
    score_questions.new(judge, submission)
  end
end
