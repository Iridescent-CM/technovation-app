module RegionalAmbassador
  class RegionalPitchEventParticipationsController < RegionalAmbassadorController
    def create
      event = current_ambassador.regional_pitch_events
        .find(assignment_params.fetch(:event_id))

      invite_params = assignment_params.fetch(:invites)

      invite_params.each do |_, par|
        # params come in strange
        # FIXME in EventTeamList.vue#saveAssignments form appending...
        opts = par.first

        invite = opts[:scope].constantize.find(opts[:id])

        invite.events << event

        # FIXME "true" == ...
        # make it a real boolean
        if "true" == opts[:send_email]
          EventMailer.invite(
            opts[:scope],
            invite.id,
            event.id
          ).deliver_later
        end
      end

      render json: {
        flash: {
          success: "You saved your selected teams for #{event.name}"
        },
      }
    end

    def destroy
      event = current_ambassador.regional_pitch_events
        .includes(:teams)
        .find(assignment_params.fetch(:event_id))

      attendee = event.teams.detect do |t|
        t.id == assignment_params.fetch(:attendee_id).to_i &&
          t.class.model_name == assignment_params.fetch(:attendee_scope)
      end

      if attendee
        attendee.events.destroy(event)

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
            success: "You removed a team from #{event.name}"
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
          :attendee_scope,
          invites: {},
        )
    end
  end
end
