module RegionalAmbassador
  class JudgeAssignmentsController < RegionalAmbassadorController
    def create
      event = current_ambassador.regional_pitch_events
        .find(assignment_params.fetch(:event_id))

      judge_params = assignment_params.fetch(:judge_ids)

      judge_params.each do |_, par|
        opts = par.first
        # params come in strange
        # FIXME in EventJudgeList.vue#saveJudgeAssignments form appending...

        judge = JudgeProfile.find(opts[:id])

        if "true" == opts[:send_invite]
          # FIXME
          JudgeMailer.invite_to_event(judge.id, event.id).deliver_later
        end

        event.judges << judge
      end

      render json: {
        flash: {
          success: "You saved your selected judges for #{event.name}"
        },
      }
    end

    def destroy
      event = current_ambassador.regional_pitch_events
        .find(assignment_params.fetch(:event_id))

      judge = JudgeProfile.find(assignment_params.fetch(:judge_id))

      if event.judges.include?(judge)
        event.judges.destroy(judge)
        JudgeMailer.notify_removed_from_event(judge.id, event.id).deliver_later
      end

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
          judge_ids: {},
        )
    end
  end
end
