module CreateJudgeAssignment
  def self.call(team:, judge:)
    judge.assigned_teams << team

    unassigned_scores_in_event = judge.submission_scores
      .current_round
      .joins(team_submission: {team: :events})
      .where("regional_pitch_events.id = ?", team.event.id)
      .where.not(team_submission: judge.assigned_teams.map(&:submission))
    unassigned_scores_in_event.destroy_all
  end
end
