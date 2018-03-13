module RegionalAmbassador
  class JudgeAssignmentsController < RegionalAmbassadorController
    def create
      judge = JudgeProfile.find(assignment_params.fetch(:judge_id))
      team = Team.find(assignment_params.fetch(:team_id))

      judge.assigned_teams << team

      render json: {
        flash: {
          success: "You assigned #{judge.name} to #{team.name}",
        },
      }
    end

    def destroy
      judge = JudgeProfile.find(assignment_params.fetch(:judge_id))
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
      )
    end
  end
end
