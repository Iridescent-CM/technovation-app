class InvalidateExistingJudgeData
  def self.call(participant)
    if participant.is_team? or participant.virtual_event?
      participant.submission_scores.current_round.destroy_all
      participant.judge_assignments.destroy_all
      participant.events.destroy_all
    end
  end
end
