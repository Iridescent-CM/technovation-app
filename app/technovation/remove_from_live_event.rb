class RemoveFromLiveEvent
  def self.call(participant)
    participant.submission_scores.destroy_all
    participant.judge_assignments.destroy_all
    participant.regional_pitch_events.destroy_all
  end
end
