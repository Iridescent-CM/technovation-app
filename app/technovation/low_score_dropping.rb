class LowScoreDropping
  def initialize(submission, options={})
    @submission = submission
    @round = options.fetch(:round)
    @score_scope = @submission.public_send("#{@round}_complete_submission_scores")
    @minimum_score_threshold = options.fetch(:minimum_score_threshold)
  end

  def able_to_drop?
    has_enough_scores? && !already_dropped?
  end

  def already_dropped?
    @score_scope.only_deleted.any? {
      |score| score.dropped?
    }
  end

  def has_enough_scores?
    @score_scope.count >= @minimum_score_threshold
  end

  def lowest_score
    @score_scope.min_by(&:total)
  end

  def average
    @submission.reload.public_send("#{@round}_average_score")
  end

  def drop!
    lowest_score.drop_score! if able_to_drop?
  end
end
