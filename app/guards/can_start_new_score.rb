module CanStartNewScore
  def self.call(judge)
    SeasonToggles.judging_enabled? &&
      !LiveEventJudgingEnabled.call(judge) &&
      judge.submission_scores.current_round.incomplete.not_recused.none?
  end
end
