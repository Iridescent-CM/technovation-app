class JudgeQuestionsForSubmissionScore
  def initialize(submission_score)
    @submission_score = submission_score
    @season = submission_score.seasons.last
    @division = submission_score.team_division_name
    @questions = "Judging::#{season_module_name}::#{questions_class_name}".constantize.new.call
  end

  def call
    questions_with_scores_populated
  end

  private

  attr_reader :submission_score, :season, :division, :questions

  def season_module_name
    case season
    when 2022
      "TwentyTwo"
    when 2021
      "TwentyOne"
    else
      if season < 2021
        raise "Questions for the #{season} season don't exist! This season was before we had seasonality for the judging questions."
      else
        raise "Questions for the #{season} season haven't been setup yet! You'll likely want to copy the previous year's queetions in '/app/services/judging/#{season - 1}/' to get them setup."
      end
    end
  end

  def questions_class_name
    case division.downcase
    when "beginner"
      "BeginnerQuestions"
    when "junior"
      "JuniorQuestions"
    when "senior"
      "SeniorQuestions"
    end
  end

  def questions_with_scores_populated
    questions.map do |question|
      question.score = submission_score.instance_eval(question.field.to_s)

      question
    end
  end
end
