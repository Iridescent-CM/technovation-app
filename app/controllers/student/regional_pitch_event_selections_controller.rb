module Student
  class RegionalPitchEventSelectionsController < StudentController
    def create
      current_team.regional_pitch_events.destroy_all
      current_team.regional_pitch_events << RegionalPitchEvent.find(params[:event_id])
      current_team.save!

      redirect_to [:student, current_team.current_team_submission],
        success: t("controllers.student.regional_pitch_event_selections.create.success")
    end
  end
end
