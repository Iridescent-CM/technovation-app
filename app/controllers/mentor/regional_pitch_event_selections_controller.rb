module Mentor
  class RegionalPitchEventSelectionsController < MentorController
    def new
      @teams = current_mentor.teams.current
        .includes(:regional_pitch_events)
    end

    def create
      event = RegionalPitchEvent.find(params[:event_id])

      event.teams << current_team

      AddTeamToRegionalEvent.(event, current_team)
      InvalidateExistingJudgeData.(current_team)

      SendPitchEventRSVPNotifications.perform_later(
        current_team.id,
        joining_event_id: event.id
      )

      redirect_to mentor_regional_pitch_events_team_list_path,
        success: "#{current_team.name} is now attending #{event.name}"
    end
  end
end
