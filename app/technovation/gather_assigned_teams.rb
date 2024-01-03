module GatherAssignedTeams
  def self.call(judge)
    teams = judge.assigned_teams

    judge_events_without_assignments = RegionalPitchEvent
      .current
      .joins(:teams)
      .left_outer_joins(judges: :judge_assignments)
      .where(
        "judge_profiles_regional_pitch_events.judge_profile_id = ?",
        judge.id
      )
      .distinct
      .select { |event| event.judge_assignments.empty? }

    if teams.empty?
      judge.events.flat_map(&:teams).uniq
    elsif judge_events_without_assignments.any?
      (teams += judge_events_without_assignments.flat_map(&:teams)).uniq
    else
      teams.uniq
    end
  end
end
