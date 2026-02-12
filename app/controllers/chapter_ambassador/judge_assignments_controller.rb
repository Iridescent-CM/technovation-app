module ChapterAmbassador
  class JudgeAssignmentsController < ChapterAmbassadorController
    def create
      @judge = JudgeProfile.find(params.fetch(:judge_id))
      @team = Team.find(params.fetch(:team_id))

      CreateJudgeAssignment.call(team: @team, judge: @judge)

      flash.now[:success] = "Successfully assigned #{@judge.name} to #{@team.name}"

      respond_to do |format|
        format.turbo_stream
      end
    end

    def destroy
      @judge = JudgeProfile.find(params.fetch(:judge_id))
      @team = Team.find(params.fetch(:team_id))

      @judge.assigned_teams.destroy(@team)

      unassigned_scores_in_event = @judge.submission_scores
        .current_round
        .joins(team_submission: {team: :events})
        .where("regional_pitch_events.id = ?", @team.event.id)
        .where.not(team_submission: @judge.assigned_teams.map(&:submission))
      unassigned_scores_in_event.destroy_all

      flash.now[:success] = "Successfully removed #{@judge.name} from #{@team.name}"

      respond_to do |format|
        format.turbo_stream
      end
    end
  end
end
