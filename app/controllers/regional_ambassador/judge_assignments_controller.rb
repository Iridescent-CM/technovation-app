module RegionalAmbassador
  class JudgeAssignmentsController < RegionalAmbassadorController
    def create
      event = current_ambassador.regional_pitch_events
        .find(assignment_params.fetch(:event_id))

      assignment_params.fetch(:ids).each do |id|
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
    end

    private
    def assignment_params
      params.require(:judge_assignment)
        .permit(
          :event_id,
          ids: [],
        )
    end
  end
end
