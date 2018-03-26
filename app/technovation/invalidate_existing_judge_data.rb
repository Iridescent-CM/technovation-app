class InvalidateExistingJudgeData
  def self.call(participant)
    participant.submission_scores.current_round.destroy_all
    participant.judge_assignments.destroy_all
    participant.events.destroy_all
  end
end
