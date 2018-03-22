module Student
  class RegionalPitchEventSelectionsController < StudentController
    before_action :require_current_team

    def create
      event = RegionalPitchEvent.find(params.fetch(:event_id))
      current_team.regional_pitch_events << event
      current_team.save!

      SendPitchEventRSVPNotifications.perform_later(
        current_team.id,
        joining_event_id: event.id
      )

      redirect_to [:student, current_team.selected_regional_pitch_event],
        success: t("controllers.student.regional_pitch_event_selections.create.success")
    end
  end
end
