class LowScoreDropping
  def initialize(submission, round:, minimum_score_count:)
    @submission = submission
    @round = round
    @minimum_score_count = minimum_score_count
  end

  def able_to_drop?
    has_enough_scores? && !already_dropped?
  end

  def already_dropped?
    scores.dropped.exists?
  end

  def has_enough_scores?
    scores.count >= @minimum_score_count
  end

  def lowest_score
    scores.min_by(&:total)
  end

  def average
    @submission.reload.public_send("#{@round}_average_score")
  end

  def drop!
    lowest_score.drop_score! if able_to_drop?
  end

  private

  def scores
    @submission.public_send("#{@round}_complete_submission_scores")
  end
end
