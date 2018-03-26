module Judge
  class AssignedSubmissionsController < JudgeController
    def index
      render json: current_judge.event.teams
        .collect(&:submission).map { |submission|
        {
          id: submission.id,
          app_name: submission.app_name,
          team_name: submission.team_name,
          team_division: submission.team_division_name,
          new_score_url: new_judge_score_path(
            team_submission_id: submission.id
          ),
        }
      }
    end
  end
end
