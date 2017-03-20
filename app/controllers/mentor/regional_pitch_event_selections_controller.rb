module Mentor
  class RegionalPitchEventSelectionsController < MentorController
    def new
      @teams = current_mentor.teams.current
    end

    def create
      params.fetch(:regional_pitch_events_teams).each do |team_id, event_id|
        team = current_mentor.teams.current.find(team_id)
        event = team.eligible_events.detect { |e| e.id.to_s == event_id }
        old_event = team.selected_regional_pitch_event

        if event
          team.regional_pitch_events.destroy_all
        else
          head 404 and return
        end

        if event.live?
          team.regional_pitch_events << event
          team.save!
        end

        SendPitchEventRSVPNotifications.perform_later(
          team.id,
          leaving_event_id: old_event.id,
          joining_event_id: event.id
        )

        head 200
      end
    end
  end
end
