module Mentor
  class RegionalPitchEventSelectionsController < MentorController
    def new
      @teams = current_mentor.teams.current
    end

    def create
      params.fetch(:regional_pitch_events_teams).each do |team_id, event_id|
        team = current_mentor.teams.current.find(team_id)
        event = team.eligible_events.detect { |e| e.id.to_s == event_id }

        if event
          team.regional_pitch_events.destroy_all
        else
          head 404 and return
        end

        if event.live?
          team.regional_pitch_events << event
          team.save!
        end

        head 200
      end
    end
  end
end
