module RegionalAmbassador
  class JudgeAssignmentsController < RegionalAmbassadorController
    def new
      @team = Team.for_ambassador(current_ambassador).find(params.fetch(:team_id))
      @judges = @team.selected_regional_pitch_event.judges.order("accounts.first_name")
      @judge_assignment = @team.build_judge_assignment
    end

    def create
      @team = Team.for_ambassador(current_ambassador).find(assignment_params.fetch(:team_id))
      event = @team.selected_regional_pitch_event
      @judge = event.judges.find(assignment_params.fetch(:judge_profile_id))

      @judge_assignment = JudgeAssignment.new(team: @team, judge_profile: @judge)

      if @judge_assignment.save
        if request.xhr?
          head 200
        else
          redirect_to regional_ambassador_regional_pitch_event_path(
            event,
            anchor: params[:referring_anchor]
          ),
          success: "You assigned #{@team.name} to judge: #{@team.assigned_judge_name}!"
        end
      else
        if request.xhr?
          render status: 422, json: @judge_assignment.errors.full_messages
        else
          render :new
        end
      end
    end

    def destroy
      assignment = JudgeAssignment.find(params[:id])
      assignment.destroy
      redirect_to "#{params[:http_referer]}##{params[:referring_anchor]}",
        success: "You removed #{assignment.team_name} from #{assignment.judge_profile_full_name}"
    end

    private
    def assignment_params
      params.require(:judge_assignment).permit(:team_id, :judge_profile_id)
    end
  end
end
