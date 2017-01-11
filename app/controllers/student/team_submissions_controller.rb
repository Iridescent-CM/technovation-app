module Student
  class TeamSubmissionsController < StudentController
    def new
      params[:step] = :affirm_integrity if params[:step].blank?
      @team_submission = current_team.team_submissions.build(step: params[:step])
    end

    def create
      @team_submission = current_team.team_submissions.build(team_submission_params)

      if @team_submission.save
        redirect_to [:student, @team_submission],
          success: t("controllers.team_submissions.create.success")
      else
        render :new
      end
    end

    def edit
      @team_submission = current_team.team_submissions.find(params.fetch(:id))
      @team_submission.step = params[:step]

      if @team_submission.technical_checklist.nil?
        @team_submission.build_technical_checklist
      end
    end

    def show
      @team_submission = current_team.team_submissions.find(params.fetch(:id))
      @team_submission.build_business_plan unless @team_submission.business_plan

      @team_photo_uploader = ImageUploader.new
      @team_photo_uploader.success_action_redirect = student_team_photo_upload_confirmation_url(back: request.fullpath)

      @screenshots_uploader = ImageUploader.new
      @screenshots_uploader.success_action_redirect = student_team_submission_screenshot_upload_confirmation_url(back: student_team_submission_path(@team_submission))

      @business_plan_uploader = FileUploader.new
      @business_plan_uploader.success_action_redirect = student_team_submission_file_upload_confirmation_url(
        file_attribute: :business_plan,
        back: student_team_submission_path(@team_submission)
      )

      @pitch_presentation_uploader = FileUploader.new
      @pitch_presentation_uploader.success_action_redirect = student_team_submission_file_upload_confirmation_url(
        file_attribute: :pitch_presentation,
        back: student_team_submission_path(@team_submission)
      )

      @source_code_uploader = FileUploader.new
      @source_code_uploader.success_action_redirect = student_team_submission_file_upload_confirmation_url(
        file_attribute: :source_code,
        back: student_team_submission_path(@team_submission)
      )
    end

    def update
      @team_submission = current_team.team_submissions.find(params.fetch(:id))

      if params[:screenshot]
        params[:screenshot].each_with_index do |id, index|
          screenshot = @team_submission.screenshots.find(id)
          screenshot.update_attributes(sort_position: index)
        end

        head 200
      elsif @team_submission.update_attributes(team_submission_params)
        if request.xhr?
          render json: {
            pitch_embed: @team_submission.embed_code(:pitch_video_link),
            demo_embed: @team_submission.embed_code(:demo_video_link),
          }
        else
          redirect_to [:student, @team_submission],
            success: t("controllers.team_submissions.update.success")
        end
      else
        render :new
      end
    end

    private
    def team_submission_params
      params.require(:team_submission).permit(
        :app_name,
        :app_description,
        :integrity_affirmed,
        :source_code_external_url,
        :stated_goal,
        :stated_goal_explanation,
        :demo_video_link,
        :pitch_video_link,
        :development_platform,
        :development_platform_other,
        business_plan_attributes: [
          :id,
          :remote_file_url,
        ],
        technical_checklist_attributes: [
          :id,
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
        ],
      ).tap do |tapped|
        tapped[:step] = params[:submission_step]

        unless tapped[:source_code_external_url].blank?
          tapped[:source_code_file_uploaded] = false
        end

        if tapped[:business_plan_attributes]
          tapped[:business_plan_attributes][:file_uploaded] = false
        end
      end
    end
  end
end
