module RegionalAmbassador
  class JudgeAssignmentsController < RegionalAmbassadorController
    def create
      model = assignment_params.fetch(:model_scope).constantize
      judge = model.find(assignment_params.fetch(:judge_id))

      team = Team.find(assignment_params.fetch(:team_id))

      judge.assigned_teams << team

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
