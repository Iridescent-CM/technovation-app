module Student
  class RegionalPitchEventSelectionsController < StudentController
    def show
      if params[:event_id]
        do_create(params)
      else
        do_destroy
      end
    end

    def create
      do_create(params)
    end

    def destroy
      do_destroy
    end

    private
    def do_destroy
      old_event = current_team.selected_regional_pitch_event

      current_team.remove_from_live_event

      SendPitchEventRSVPNotifications.perform_later(
        current_team.id,
        leaving_event_id: old_event.id
      )

      redirect_to [:student, :dashboard],
        success: t("controllers.student.regional_pitch_event_selections.destroy.success")
    end

    def do_create(params)
      old_event = current_team.selected_regional_pitch_event

      current_team.remove_from_live_event

      event = RegionalPitchEvent.find(params.fetch(:event_id))
      current_team.regional_pitch_events << event
      current_team.save!

      SendPitchEventRSVPNotifications.perform_later(
        current_team.id,
        leaving_event_id: old_event.id,
        joining_event_id: event.id
      )

      if current_team.submission.pitch_presentation_complete?
        redirect_to [:student, current_team.selected_regional_pitch_event],
          success: t("controllers.student.regional_pitch_event_selections.create.success")
      else
        redirect_to new_student_team_submission_pitch_presentation_path,
          success: t("controllers.student.regional_pitch_event_selections.create.success_pitch_needed")
      end
    end
  end
end
