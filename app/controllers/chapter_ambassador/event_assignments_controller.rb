module ChapterAmbassador
  class EventAssignmentsController < ChapterAmbassadorController
    def create
      event = RegionalPitchEvent.find(assignment_params.fetch(:event_id))
      CreateEventAssignment.call(event, assignment_params.merge({invited_by_id: current_ambassador.account.id}))

      render json: {
        flash: {
          success: "You saved your selected attendees for #{event.name}"
        },
      }
    end

    def destroy
      event = RegionalPitchEvent
        .includes(:judges, :user_invitations)
        .find(assignment_params.fetch(:event_id))

      attendee = assignment_params.fetch(:attendee_scope).constantize
        .find(assignment_params.fetch(:attendee_id))

      if event.attendees.include?(attendee)
        InvalidateExistingJudgeData.(attendee, removing: true, event: event)

        if assignment_params.fetch(:attendee_scope) == "Team"
          attendee.memberships.each do |membership|
            EventMailer.notify_removed(
              membership.member_type,
              membership.member_id,
              event.id,
              team_name: attendee.name
            ).deliver_later
          end
        else
          EventMailer.notify_removed(
            attendee.class.name,
            attendee.id,
            event.id,
          ).deliver_later
        end
      end

      render json: {
        flash: {
          success: "You removed #{attendee.name} from #{event.name}"
        },
      }
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
