module ChapterAmbassador
  class JudgeAssignmentsController < ChapterAmbassadorController
    def create
      model = assignment_params.fetch(:model_scope).constantize
      judge = model.find(assignment_params.fetch(:judge_id))
      team = Team.find(assignment_params.fetch(:team_id))

      CreateJudgeAssignment.(team: team, judge: judge)

      render json: {
        flash: {
          success: "You assigned #{judge.name} to #{team.name}",
        },
      }
    end

    def destroy
      model = assignment_params.fetch(:model_scope).constantize
      judge = model.find(assignment_params.fetch(:judge_id))

      team = Team.find(assignment_params.fetch(:team_id))

      judge.assigned_teams.destroy(team)

      unassigned_scores_in_event = judge.submission_scores
        .current_round
        .joins(team_submission: { team: :events })
        .where("regional_pitch_events.id = ?", team.event.id)
        .where.not(team_submission: judge.assigned_teams.map(&:submission))
      unassigned_scores_in_event.destroy_all

      render json: {
        flash: {
          success: "You removed #{judge.name} from #{team.name}",
        },
      }
    end

    private
    def assignment_params
      params.require(:judge_assignment).permit(
        :judge_id,
        :team_id,
        :model_scope,
      )
    end
  end
end
