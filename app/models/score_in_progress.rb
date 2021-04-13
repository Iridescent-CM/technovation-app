class ScoreInProgress
  attr_reader :judge, :score

  def initialize(judge)
    @judge = judge
    @score = judge.submission_scores.current_round.incomplete.not_recused.last
  end

  def present?
    score.present?
  end

  def id
    score.id
  end

  def submission_name
    score.team_submission.app_name
  end

  def team_name
    score.team_submission.team_name
  end

  def team_division
    score.team_division_name
  end

  def total
    score.total
  end

  def possible
    score.total_possible
  end
end
