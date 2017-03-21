module RegionalAmbassador
  class RegionalPitchEventParticipationsController < RegionalAmbassadorController
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
        success: "You removed #{record.class.name} #{record.name} from your event"
    end
  end
end
