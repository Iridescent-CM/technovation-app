module ShouldFinishScoreInProgress
  def self.call(judge)
    SeasonToggles.judging_enabled? and
      not judge.live_event? and
        judge.submission_scores.current_round.incomplete.any?
  end
end
