module Student
  class TeamSubmissionsController < StudentController
    before_action :require_full_access,
                  :require_current_team

    def new
      @team_submission = if current_team.submission.present?
                           current_team.submission
                         else
                           current_team.team_submissions.build
                         end
    end

    def edit
      redirect_to student_dashboard_path, alert: "Sorry, can't go there"
    end

    def create
      @team_submission = if current_team.submission.present?
                           current_team.submission
                         else
                           current_team.team_submissions.build(
                             team_submission_params
                           )
                         end

      if @team_submission.save
        redirect_to [:student, @team_submission],
          success: t("controllers.team_submissions.create.success")
      else
        render :new
      end
    end

    def show
      @team_submission = current_team.submission

      if not @team_submission.present?
        redirect_to student_dashboard_path and return
      end

      unless @team_submission.pitch_presentation.present?
        @team_submission.build_pitch_presentation
      end

      @pitch_presentation_uploader = FileUploader.new
      @pitch_presentation_uploader.success_action_redirect =
        student_team_submission_file_upload_confirmation_url(
          file_attribute: :pitch_presentation,
          back: student_team_submission_path(@team_submission)
        )
    end

    def update
      @team_submission = current_team.submission

      if team_submission_params[:screenshots]
        team_submission_params[:screenshots].each_with_index do |id, index|
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
      sub_params = if SeasonToggles.team_submissions_editable?
                    params.require(:team_submission).permit(
                      :integrity_affirmed,
                      :source_code,
                      :source_code_external_url,
                      :app_description,
                      :stated_goal,
                      :stated_goal_explanation,
                      :app_name,
                      :demo_video_link,
                      :pitch_video_link,
                      :development_platform_other,
                      :development_platform,
                      :source_code_file_uploaded,
                      pitch_presentation_attributes: [
                        :id,
                        :remote_file_url,
                      ],
                    )
                   else
                    params.require(:team_submission).permit(
                      pitch_presentation_attributes: [
                        :id,
                        :remote_file_url,
                      ],
                    )
                   end
      sub_params.tap do |tapped|
        if tapped[:pitch_presentation_attributes]
          tapped[:pitch_presentation_attributes][:file_uploaded] = false
        end
      end
    end
  end
end
