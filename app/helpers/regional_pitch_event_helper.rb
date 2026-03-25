module RegionalPitchEventHelper
  def show_team_and_judge_assignment_count?(event)
    event.meets_requirement_to_assign_judges_to_teams? || event.judge_assignments.exists?
  end
end
