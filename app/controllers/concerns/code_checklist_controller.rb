module CodeChecklistController
  def update
    unless SeasonToggles.team_submissions_editable?
      redirect_to dashboard_path and return
    end

    @team_submission = TeamSubmission.find(params[:team_submission_id])
    @code_checklist = if @team_submission.code_checklist.present?
                        @team_submission.code_checklist
                      else
                        @team_submission.build_code_checklist
                      end

    if @code_checklist.update(code_checklist_params)
      current_team.create_activity(
        trackable: current_account,
        key: "submission.update",
        parameters: { piece: "code_checklist" },
        recipient: @team_submission,
      )

      redirect_to [current_scope, @team_submission],
        success: "Your code checklist was saved!"
    else
      render "team_submissions/pieces/code_checklist"
    end
  end

  private
  def code_checklist_params
    params.require(:technical_checklist).permit(
      :used_strings,
      :used_strings_explanation,
      :used_numbers,
      :used_numbers_explanation,
      :used_variables,
      :used_variables_explanation,
      :used_lists,
      :used_lists_explanation,
      :used_booleans,
      :used_booleans_explanation,
      :used_loops,
      :used_loops_explanation,
      :used_conditionals,
      :used_conditionals_explanation,
      :used_local_db,
      :used_local_db_explanation,
      :used_external_db,
      :used_external_db_explanation,
      :used_location_sensor,
      :used_location_sensor_explanation,
      :used_camera,
      :used_camera_explanation,
      :used_accelerometer,
      :used_accelerometer_explanation,
      :used_sms_phone,
      :used_sms_phone_explanation,
      :used_sound,
      :used_sound_explanation,
      :used_sharing,
      :used_sharing_explanation,
      :used_clock,
      :used_clock_explanation,
      :used_canvas,
      :used_canvas_explanation,
      :paper_prototype,
      :paper_prototype_cache,
      :event_flow_chart,
      :event_flow_chart_cache,
    )
  end

  def dashboard_path
    send("#{current_scope}_dashboard_path")
  end

  def new_team_submission_path
    send(
      "new_#{current_scope}_team_submission_path",
      team_id: @team_submission.team_id
    )
  end
end
