module Student
  class RegionalPitchEventSelectionsController < StudentController
    def create
      current_team.regional_pitch_events.destroy_all
      current_team.regional_pitch_events << RegionalPitchEvent.find(params[:event_id])
      current_team.save!

      redirect_to [:student, current_team.selected_regional_pitch_event],
        success: t("controllers.student.regional_pitch_event_selections.create.success")
    end

    def destroy
      current_team.regional_pitch_events.destroy_all
      redirect_to [:student, :dashboard],
        success: t("controllers.student.regional_pitch_event_selections.destroy.success")
    end
  end
end
