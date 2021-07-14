module Student
  class RegionalPitchEventSelectionsController < StudentController
    before_action :require_current_team

    def create
      event = RegionalPitchEvent.find(params.fetch(:event_id))

      begin

        AddTeamToRegionalEvent.(event, current_team)
        redirect_to student_regional_pitch_event_path(current_team.selected_regional_pitch_event),
          success: t("controllers.student.regional_pitch_event_selections.create.success")

      rescue AddTeamToRegionalEvent::EventAtTeamCapacityError => ex

        redirect_back fallback_location: student_regional_pitch_events_url,
          error: t("controllers.student.regional_pitch_event_selections.create.event_full")

      end
    end
  end
end
