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

      attendee = JudgeProfile.find(assignment_params.fetch(:attendee_id))

      if event.judges.include?(attendee)
        event.judges.destroy(attendee)

        EventMailer.notify_removed(
          attendee.class.name,
          attendee.id,
          event.id,
        ).deliver_later
      end

      render json: {
        flash: {
          success: "You removed #{attendee.full_name} from #{event.name}"
        },
      }
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
