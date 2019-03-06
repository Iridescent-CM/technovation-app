module CanStartNewScore
  def self.call(judge)
    SeasonToggles.judging_enabled? and
      not LiveEventJudgingEnabled.(judge) and
        judge.submission_scores.current_round.incomplete.none?
  end
end
