class ScoreInProgress
  attr_reader :judge, :score

  def initialize(judge)
    @judge = judge
    @score = judge.submission_scores.current_round.incomplete.last
  end

  def id
    score.id
  end
end
