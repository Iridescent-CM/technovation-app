module Student
  class RegionalPitchEventSelectionsController < StudentController
    before_action :require_current_team

    def create
      event = RegionalPitchEvent.find(params.fetch(:event_id))

      if event.at_team_capacity?
        redirect_back fallback_location: student_regional_pitch_events_url,
          error: t("controllers.student.regional_pitch_event_selections.create.event_full")
      else
        AddTeamToRegionalEvent.(event, current_team)

        redirect_to [:student, current_team.selected_regional_pitch_event],
          success: t("controllers.student.regional_pitch_event_selections.create.success")
      end
    end
  end
end
