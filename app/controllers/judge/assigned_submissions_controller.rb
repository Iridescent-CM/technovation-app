module Judge
  class AssignedSubmissionsController < JudgeController
    def index
      teams = current_judge.assigned_teams
      teams = current_judge.events.flat_map(&:teams) if teams.empty?

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
