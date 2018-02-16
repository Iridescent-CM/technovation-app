module RegionalAmbassador
  class JudgeAssignmentsController < RegionalAmbassadorController
    def create
      event = current_ambassador.regional_pitch_events
        .find(assignment_params.fetch(:event_id))

      invite_params = assignment_params.fetch(:invites)

      invite_params.each do |_, par|
        # params come in strange
        # FIXME in EventJudgeList.vue#saveAssignments form appending...
        opts = par.first

        if opts[:id].blank?
          invite = UserInvitation.create!({
            email: opts[:email],
            name: opts[:name],
            profile_type: :judge,
          });
          event.invites << invite
        else
          invite = JudgeProfile.find(opts[:id])
          event.judges << invite
        end

        # FIXME "true" == ...
        # make it a real boolean
        if "true" == opts[:send_email]
          EventMailer.invite(invite.class.name, invite.id, event.id).deliver_later
        end
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

      attendee = event.judge_list.detect do |j|
        j.id == assignment_params.fetch(:attendee_id).to_i
      end

      if attendee && attendee.is_a?(JudgeProfile)
        event.judges.destroy(attendee)
      elsif attendee && attendee.is_a?(UserInvitation)
        event.invites.destroy(attendee)
      end

      if attendee
        EventMailer.notify_removed(
          attendee.class.name,
          attendee.id,
          event.id,
        ).deliver_later

        render json: {
          flash: {
            success: "You removed #{attendee.name} from #{event.name}"
          },
        }
      else
        render json: {
          flash: {
            success: "You removed a judge from #{event.name}"
          },
        }
      end
    end

    private
    def assignment_params
      params.require(:event_assignment)
        .permit(
          :event_id,
          :attendee_id,
          invites: {},
        )
    end
  end
end
