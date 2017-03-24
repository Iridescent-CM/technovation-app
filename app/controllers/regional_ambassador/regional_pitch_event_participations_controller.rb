module RegionalAmbassador
  class RegionalPitchEventParticipationsController < RegionalAmbassadorController
    def new
      @event = current_ambassador.regional_pitch_events.find(params.fetch(:event_id))

      case params.fetch(:participant_type)
      when "Team"
        @participants = Team.current
          .public_send(params.fetch(:division))
          .for_ambassador(current_ambassador)
          .not_attending_live_event
      end
    end

    def create
      event = current_ambassador.regional_pitch_events.find(params.fetch(:event_id))
      record = params.fetch(:participant_type).constantize.find(params.fetch(:participant_id))

      old_event = record.selected_regional_pitch_event

      record.regional_pitch_events.destroy_all

      record.regional_pitch_events << event
      record.save!

      if record.is_a?(Team)
        SendPitchEventRSVPNotifications.perform_later(
          record.id,
          ra_removed_participant_from: old_event.id,
          ra_added_participant_to: event.id,
        )
      end

      redirect_to regional_ambassador_regional_pitch_event_path(event),
        success: "You added #{record.class.name} #{record.name rescue record.full_name} to your event!"
    end

    def destroy
      event = current_ambassador.regional_pitch_events.find(params[:id])
      record = params.fetch(:participant_type).constantize.find(params.fetch(:participant_id))

      record.regional_pitch_events.destroy_all

      if record.is_a?(Team)
        SendPitchEventRSVPNotifications.perform_later(
          record.id,
          ra_removed_participant_from: event.id,
        )
      end

      redirect_to regional_ambassador_regional_pitch_event_path(event),
        success: "You removed #{record.class.name} #{record.name rescue record.full_name} from your event"
    end
  end
end
