class InvalidateExistingJudgeData
  def self.call(participant, opts = {})
    if participant.is_team? or participant.virtual_event?
      participant.submission_scores.current_round.destroy_all
      participant.judge_assignments.destroy_all
      participant.events.destroy_all
    end

    if opts.fetch(:removing) { false }
      event = opts.fetch(:event)

      event_scores_by_this_judge = SubmissionScore
        .includes(team_submission: {team: :events})
        .references(:regional_pitch_events)
        .where(judge_profile_id: participant.id)
        .where("regional_pitch_events.id = ?", event.id)

      event_scores_by_this_judge.destroy_all
      participant.events.destroy(event)
    end
  end
end
