class JudgeQuestionsForSubmissionScore
  def initialize(submission_score, judge_questions_constructor: JudgeQuestions)
    @submission_score = submission_score
    @submission_type = submission_score.team_submission_submission_type
    @questions = judge_questions_constructor
      .new(season: submission_score.seasons.last, division: submission_score.team_division_name)
      .call
  end

  def call
    questions_with_scores_populated
  end

  private

  attr_reader :submission_score, :submission_type, :questions

  def questions_with_scores_populated
    filtered_questions.map do |question|
      question.score = submission_score.instance_eval(question.field.to_s)

      question
    end
  end

  def filtered_questions
    questions.delete_if do |question|
      question.section == "demo" && question.submission_type != submission_type
    end
  end
end
