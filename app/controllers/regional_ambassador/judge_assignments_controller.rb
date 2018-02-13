module RegionalAmbassador
  class JudgeAssignmentsController < RegionalAmbassadorController
    def create
      event = current_ambassador.regional_pitch_events
        .find(assignment_params.fetch(:event_id))

      assignment_params.fetch(:judge_ids).each do |id|
        judge = JudgeProfile.find(id)
        event.judges << judge
      end

      render json: {
        flash: {
          success: "Your judge assignments were saved!",
        },
      }
    end

    def destroy
      event = current_ambassador.regional_pitch_events
        .find(assignment_params.fetch(:event_id))

      judge = JudgeProfile.find(assignment_params.fetch(:judge_id))

      event.judges.destroy(judge)

      render json: {
        flash: {
          success: "You removed #{judge.full_name} from #{event.name}"
        },
      }
    end

    private
    def assignment_params
      params.require(:judge_assignment)
        .permit(
          :event_id,
          :judge_id,
          judge_ids: [],
        )
    end
  end
end
