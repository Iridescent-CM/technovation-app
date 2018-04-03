module Mentor
  class RegionalPitchEventSelectionsController < MentorController
    def new
      @teams = current_mentor.teams.current
        .includes(:regional_pitch_events)
    end

    def create
      event = RegionalPitchEvent.find(params[:event_id])

      AddTeamToRegionalEvent.(event, current_team)

      redirect_to mentor_regional_pitch_events_team_list_path,
        success: "#{current_team.name} is now attending #{event.name}"
    end
  end
end
