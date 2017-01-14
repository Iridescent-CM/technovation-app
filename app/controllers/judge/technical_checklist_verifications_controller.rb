module Judge
  class TechnicalChecklistVerificationsController < JudgeController
    helper_method :current_team_submission

    def new
      @technical_checklist = current_team_submission.technical_checklist ||
        current_team_submission.build_technical_checklist
    end

    def create
      @technical_checklist = current_team_submission.technical_checklist ||
        current_team_submission.build_technical_checklist

      @technical_checklist.update_attributes(technical_checklist_params)

      redirect_to new_judge_team_submission_technical_checklist_verification_path(
        current_team_submission
      ), success: t("controllers.judge.technical_checklist_verifications.create.success")
    end

    private
    def current_team_submission
      @current_team_submission ||= TeamSubmission.find(params[:team_submission_id])
    end

    def technical_checklist_params
      params.require(:technical_checklist).permit(
        :used_strings_verified,
        :used_numbers_verified,
        :used_variables_verified,
        :used_lists_verified,
        :used_booleans_verified,
        :used_loops_verified,
        :used_conditionals_verified,
        :used_local_db_verified,
        :used_external_db_verified,
        :used_location_sensor_verified,
        :used_camera_verified,
        :used_accelerometer_verified,
        :used_sms_phone_verified,
        :used_sound_verified,
        :used_sharing_verified,
        :used_clock_verified,
        :used_canvas_verified,
        :paper_prototype_verified,
        :event_flow_chart_verified,
      )
    end
  end
end
