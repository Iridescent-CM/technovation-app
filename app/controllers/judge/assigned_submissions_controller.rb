module Judge
  class AssignedSubmissionsController < JudgeController
    def index
      teams = current_judge.assigned_teams

      judge_events_without_assignments = RegionalPitchEvent
        .current
        .joins(:teams)
        .left_outer_joins(judges: :judge_assignments)
        .where(
          "judge_profiles_regional_pitch_events.judge_profile_id = ?",
          current_judge.id
        )
        .distinct
        .select { |event| event.judge_assignments.empty? }

      if teams.empty?
        teams = current_judge.events.flat_map(&:teams)
      elsif judge_events_without_assignments.any?
        teams += judge_events_without_assignments.flat_map(&:teams)
      end

      current_scores = current_judge.submission_scores.current_round

      render json: teams.collect(&:submission).map { |submission|
        {
          id: submission.id,
          app_name: submission.app_name,
          team_name: submission.team_name,
          team_division: submission.team_division_name,

          new_score_url: new_judge_score_path(
            team_submission_id: submission.id
          ),

          score_started: current_scores.incomplete
            .pluck(:team_submission_id).include?(submission.id),

          score_finished: current_scores.complete
            .pluck(:team_submission_id).include?(submission.id),
        }
      }
    end
  end
end
